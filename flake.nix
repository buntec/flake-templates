{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      scala-cli-app = {
        path = ./scala-cli-app;
        description = "A Scala app built with scala-cli";
      };

    };

    defaultTemplate = self.templates.scala-cli-app;

  };
}
