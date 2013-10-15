---
layout: post
title:  "Deploying to AWS using elastic beanstalk"
date:   2013-10-14
author: Akshay Karle
categories: AWS Elastic-Beanstalk Deployments
---

Snap now has the [aws cli](http://aws.amazon.com/cli/) installed on all build boxes. This allows you to deploy to AWS using [Amazon's elastic beanstalk](http://aws.amazon.com/elasticbeanstalk/).

To deploy to AWS you need to perform the following steps:
* Create an elastic beanstalk application to deploy.
* Create an environment where you wish to deploy your application.
* Create a S3 bucket where you can store your application to be deployed.
* Create an application version to deploy.

In order to start using Snap for AWS deployments, we need to setup an elastic beanstalk application and environment on AWS as shown in the figures below:

![elastic beanstalk home](/assets/images/screenshots/aws-elastic-beanstalk/elastic-beanstalk-home.png){: .screenshot}

![create new application](/assets/images/screenshots/aws-elastic-beanstalk/application-info.png){: .screenshot}

![environment type](/assets/images/screenshots/aws-elastic-beanstalk/environment-type.png){: .screenshot}

![application version](/assets/images/screenshots/aws-elastic-beanstalk/application-version.png){: .screenshot}

![environment info](/assets/images/screenshots/aws-elastic-beanstalk/environment-info.png){: .screenshot}

![additional resources](/assets/images/screenshots/aws-elastic-beanstalk/additional-resources.png){: .screenshot}

![configuration details](/assets/images/screenshots/aws-elastic-beanstalk/configuration-details.png){: .screenshot}

![review information](/assets/images/screenshots/aws-elastic-beanstalk/review-information.png){: .screenshot}

Once you've created a application and an environment using elastic beanstalk, you can now proceed to configuring your project on Snap to start deploying to AWS. To deploy to AWS we will be adding two stages to your build pipeline:

1. A InstallZip stage to:
  * Download zip source code
  * Install zip on your build box

2. A Deploy stage to:
  * Create a zip file of your current build
  * Upload the zip file to a S3 bucket for deployment
  * Create a new application version to deploy
  * Update the environment to use the application version

To configure your project edit your build plan from the project configuration page as shown below:

![build plan edit](/assets/images/screenshots/aws-elastic-beanstalk/build-plan-edit.png){: .screenshot}

Next click on ADD NEW and select Custom stage. Enter *InstallZip* as the stage name and enter the following commands:

{% highlight bash %}
wget ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz
tar -zxf zip30.tgz
cd zip30 && make -f unix/Makefile generic_gcc
cd zip30 && make prefix=$HOME -f unix/Makefile install
{% endhighlight %}

Now click Add to create the InstallZip stage.

Next click on ADD NEW and select Custom stage again to add a another stage. Enter *Deploy* as the stage name and enter the following commands:

{% highlight bash %}
$HOME/bin/zip -r "APP_NAME.zip" *
aws elasticbeanstalk delete-application-version --application-name "APP_NAME" --version-label `git rev-parse --short HEAD` --delete-source-bundle
aws s3 cp APP_NAME.zip s3://S3_BUCKET_NAME/APP_NAME-`git rev-parse --short HEAD`.zip
aws elasticbeanstalk create-application-version --application-name "APP_NAME" --version-label `git rev-parse --short HEAD` --source-bundle S3Bucket="S3_BUCKET_NAME",S3Key="APP_NAME-`git rev-parse --short HEAD`.zip"
aws elasticbeanstalk update-environment --environment-name "ENVIRONMENT_NAME" --version-label `git rev-parse --short HEAD`
{% endhighlight %}

Note that we first delete any existing application versions with the same version label before creating a new application version with that label. This is done to ensure that you deploy the current build and not any previous versions.

Next click on the Environment Variables tab and add the following environment variables:

* Key: AWS_ACCESS_KEY_ID      Value: YOUR_AWS_ACCESS_KEY_ID
* Key: AWS_SECRET_ACCESS_KEY  Value: YOUR_AWS_SECRET_ACCESS_KEY
* Key: AWS_DEFAULT_REGION     Value: YOUR_AWS_DEFAULT_REGION(set this to us-east-1 if you did not change it when setting up the application)

Click Add to create the Deploy stage.
Now, click Save and Re-run and wait for the pipeline to go complete and voila, you can now view your elastic beanstalk dashboard to see the status of your newly deployed application.

![elastic beanstalk dashboard](/assets/images/screenshots/aws-elastic-beanstalk/elastic-beanstalk-dashboard.png){: .screenshot}

For more information see [aws cli reference](http://docs.aws.amazon.com/cli/latest/reference/), [elastic beanstalk](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html).
