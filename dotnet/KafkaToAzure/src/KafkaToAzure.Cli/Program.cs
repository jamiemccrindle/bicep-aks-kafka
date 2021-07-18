using System;
using System.IO;
using System.Threading;
using McMaster.Extensions.CommandLineUtils;

namespace KafkaToAzure.Cli
{
    class Program
    {
        public static int Main(string[] args)
        {
            var app = new CommandLineApplication
            {
                Name = "kafka-to-azure",
                Description = "Kafka to Azure",
            };

            app.HelpOption(inherited: true);
            app.Command("sync", configCmd =>
            {
                // going to need the connection to kafka and the connection to cosmosdb
                // will need to listen to the kafka topics
                // and will need to write to cosmosdb
                // will need to listen to the cosmosdb change feed and write to kafka
                // kafka connection info
                // cosmos connection info
                // mapping
                configCmd.OnExecute(() =>
                {
                    Console.WriteLine("Hello");
                    return 1;
                });
            });

            app.Command("spam", configCmd =>
            {
                var configOption = configCmd.Option<string>("--config", "Config File", CommandOptionType.SingleValue).IsRequired();
                var topicOption = configCmd.Option<string>("--topic", "Topic Name", CommandOptionType.SingleValue).IsRequired();
                configCmd.OnExecuteAsync(async (token) =>
                {
                    var spammer = new KafkaMessageSpammer();
                    await spammer.Run(new KafkaMessageSpammerArgs {
                        Topic = topicOption.Value(),
                        ConfigFile = configOption.Value() 
                    }, CancellationToken.None);
                    return 1;
                });
            });

            app.Command("receiver", configCmd =>
            {
                var configOption = configCmd.Option<string>("--config", "Config File", CommandOptionType.SingleValue).IsRequired();
                var topicOption = configCmd.Option<string>("--topic", "Topic Name", CommandOptionType.SingleValue).IsRequired();
                var groupIdOption = configCmd.Option<string>("--group-id", "Group Id", CommandOptionType.SingleValue);
                configCmd.OnExecuteAsync(async (token) =>
                {
                    var receiver = new KafkaMessageReceiver();
                    await receiver.Run(new KafkaMessageReceiverArgs {
                        Topic = topicOption.Value(),
                        ConfigFile = configOption.Value(),
                        GroupId = groupIdOption.HasValue() ? groupIdOption.Value() : "kafka-to-azure-receiver"
                    }, CancellationToken.None);
                    return 1;
                });
            });

            app.OnExecute(() =>
            {
                Console.WriteLine("Specify a subcommand");
                app.ShowHelp();
                return 1;
            });

            return app.Execute(args);
        }
    }
}
