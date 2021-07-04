# goHugo-serverless-aws

A set of templates to help you get started in building your [Hugo](https://gohugo.io/) static site on AWS

### AWS Setup

1. Ensure you have setup you MFA login access to your aws account
2. Create and Activate your aws key and secret
3. Create a Github Personal Access Token and using AWS Secrets Manager, create a secret which has your github user and token, so aws codepipeline can pull the latest commit from your desired branch to deploy
4. In the aws-infrastructure folder, update the init-pipeline.sh with your local aws role/profile, region and cloudformation stack name. It's important that whatever stack name you enter here, must be the same across the other cloudformation parameters for the pipeline.yml. For this first step, you need to make sure that the init-pipeline.json and the pipeline.json have the same parameter values set.
5. Before running the init-pipeline script, comment out the pipeline.yml actions after the "AdministerPipeline" step. You can enable the rest once you have the pipeline working from git commit triggers.
6. Running the init-pipeline.sh script will deploy a cloudformation template that builds your aws codepipeline.
7. Once you have your aws codepipeline successfully triggering from your github commits on the branch you have configured, you can then uncomment the Cloudfront CDN template to deploy. You no longer need aws cli access from your dev workstation, as we are updating all infrastructure and content through git now. Delete those AWS keys from your machine and AWS console.
8. After Cloudfront has been successfully deployed, you can enable the last step to publish your Hugo content with Codebuild.

You can reference more cloudfront configuration parameters from aws site [CloudFront Resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_CloudFront.html)

### Hugo site configuration

1. I have already got you started with the [Hugo quick start guide](https://gohugo.io/getting-started/quick-start/), which sets up the quickstart directory, the Ananke theme and "my-first-post" :-)
2. I have also included a hugo binary in the "/bin" folder which will be used by Codebuild to generate your static content. Ideally you should have this in an artifact bucket/store you can call from codebuild. This is a 66MB file, so I don't recommend you store it in Github, I have only included it in the codebuild steps to help demonstrate the use of the binary, so please move it to a separate artifact bucket.
3. There is also Dockerfile-Hugo, which shows the steps on how to compile the Hugo binary with a specific version.
4. One thing to note when working with AWS S3 private bucket, Cloudfront and Hugo static site generator, you will have to enable **uglyURLS = true** in hugo's config.toml file, as we are using index.html as the Cloudfront root object. If you don't, you will get 404's if you use index.html in other directories of the your static site directory structure

You can read further on how to configure your Hugo config.toml file to tailor it to your style here: [Further Hugo Configuration](https://gohugo.io/getting-started/configuration/)
