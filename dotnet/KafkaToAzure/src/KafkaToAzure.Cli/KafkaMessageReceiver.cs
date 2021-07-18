using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Confluent.Kafka;

namespace KafkaToAzure.Cli
{

    public class KafkaMessageReceiverArgs
    {
        public string ConfigFile { get; set; }
        public string Topic { get; set; }
        public string GroupId { get; set; }
    }


    public class KafkaMessageReceiver
    {
        public async Task Run(KafkaMessageReceiverArgs args, CancellationToken cancellationToken)
        {
            // todo: this is a terrible properties parser
            var configProperties = (await File.ReadAllLinesAsync(args.ConfigFile)).Aggregate(new Dictionary<string, string>(), (result, line) =>
            {
                var keyValue = line.Split('=', 2);
                result.Add(keyValue[0], keyValue[1]);
                return result;
            });
            var config = new ConsumerConfig(configProperties);
            config.GroupId = args.GroupId;
            config.EnablePartitionEof = true;
            config.EnableAutoCommit = true;
            config.AutoOffsetReset = AutoOffsetReset.Earliest;
            config.SessionTimeoutMs = 6000;
            config.StatisticsIntervalMs = 5000;
            using var consumer = new ConsumerBuilder<string, string>(config)
                .SetErrorHandler((_, e) => Console.WriteLine($"Error: {e.Reason}"))
                .SetStatisticsHandler((_, json) => Console.WriteLine($"Statistics: {json}"))
                .Build();
            var key = Guid.NewGuid().ToString();
            consumer.Subscribe(new List<string> { args.Topic });
            Console.WriteLine("Starting to receive");
            while (true)
            {
                var consumeResult = consumer.Consume(cancellationToken);
                Console.WriteLine(JsonSerializer.Serialize(new {
                    consumeResult.Message.Key,
                    consumeResult.Message.Value,
                    consumeResult.Message.Timestamp,
                }));
                if (consumeResult.IsPartitionEOF)
                {
                    Console.WriteLine(
                        $"Reached end of topic {consumeResult.Topic}, partition {consumeResult.Partition}, offset {consumeResult.Offset}.");
                    break;
                }
            }
        }
    }
}
