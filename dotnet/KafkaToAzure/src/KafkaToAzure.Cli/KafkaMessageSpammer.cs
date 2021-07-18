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

    public class KafkaMessageSpammerArgs
    {
        public string ConfigFile { get; set; }
        public string Topic { get; set; }
        public int MessagesToSend { get; set; }
    }


    public class KafkaMessageSpammer
    {
        public async Task Run(KafkaMessageSpammerArgs args, CancellationToken cancellationToken)
        {
            // todo: this is a terrible properties parser
            var configProperties = (await File.ReadAllLinesAsync(args.ConfigFile)).Aggregate(new Dictionary<string,string>(), (result, line) => {
                var keyValue = line.Split('=', 2);
                result.Add(keyValue[0], keyValue[1]);
                return result;
            });
            var config = new ProducerConfig(configProperties);
            using var producer = new ProducerBuilder<string, string>(config).Build();
            for(var i = 0; i < args.MessagesToSend; i++) {
            var key = Guid.NewGuid().ToString();
            var deliveryReport = await producer.ProduceAsync(
                args.Topic, new Message<string, string>
                {
                    Timestamp = new Timestamp(DateTime.UtcNow),
                    Key = JsonSerializer.Serialize(new
                    {
                        id = key
                    }),
                    Value = JsonSerializer.Serialize(new
                    {
                        id = key
                    })
                });
                Console.WriteLine(JsonSerializer.Serialize(deliveryReport));
            }
        }
    }
}
