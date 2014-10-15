---
layout: post
title:  "AWS Elastic Beanstalk revisited"
date:   2014-10-17
author: Akshay Karle
categories: announcements feature deployments
---

We had [previously demonstrated a way to deploy your application to Elastic Beanstalk]({% post_url 2013-10-21-aws-elastic-beanstalk %}) which involved creating a zip of your application and doing a bunch of other aws commands. Today I'm excited to announce new improved and highly simplified in deployments to the beanstalk. Now you can use Snap's [Elastic Beanstalk Deploy recipe](http://docs.snap-ci.com/deployments/aws-deployments/#using-elastic-beanstalk-to-deploy-to-aws) to simplify your deployments. You need to setup a beanstalk application in aws just as before. Have a look at the [AWS getting started guide](http://aws.amazon.com/elasticbeanstalk/getting-started/) or our [previous blog]({% post_url 2013-10-21-aws-elastic-beanstalk %}) for steps on how to create a beanstalk application.

> *TIP:* When creating the Elastic Beanstalk application on the AWS select a `Sample Application` and later when deploying through Snap supply a S3 bucket.

Once you have setup the application on AWS you can deploy from Snap by following 3 simple steps:

* Add a Elastic Beanstalk Deploy stage to your pipeline configuration.
* Enter the Application name, Environment name, the S3 bucket and AWS credentials to the stage.
* Hit save and watch your changes get deployed to Elastic BeanStalk.



## Add a Elastic Beanstalk Deploy stage to your pipeline configuration

Visit your pipeline configuration edit page and select the add new stage. Select the `Elastic Beanstalk Deploy` recipe from the Deploy category.

![Add Stage](/assets/images/screenshots/aws-elastic-beanstalk-revisited/add-stage@2x.png){: .screenshot .big}



## Enter the Application name, Environment name, the S3 bucket and AWS credentials to the stage.

You can find the Application name and Environment name from the Elastic Beanstalk dashboard in the AWS console.

![AWS console for Application name](/assets/images/screenshots/aws-elastic-beanstalk-revisited/elastic-beanstalk-dashboard@2x.png){: .screenshot .big}

To deploy your application from Snap you also need to create a S3 bucket where snap can push the zipped app for Elastic beanstalk to fetch. Once you have created the s3 bucket enter the name of the S3 bucket in the `snap-deploy` command alongwith the Application name and the Environment name. You may also need to change the AWS region option, the default is us-east-1 (N. Virginia).

![enter credentials](/assets/images/screenshots/aws-elastic-beanstalk-revisited/enter-stage-data@2x.png){: .screenshot .big}


Have a look at our [docs](http://docs.snap-ci.com/deployments/aws-deployments/#using-elastic-beanstalk-to-deploy-to-aws%23command-line-usage-of-snap-deploy-for-opsworks-deployments) to get more details on the different options available for Elastic Beanstalk.



## Hit save and watch your changes get deployed to Elastic BeanStalk

![Snap deploy logs](/assets/images/screenshots/aws-elastic-beanstalk-revisited/deploy-console-logs@2x.png){: .screenshot .big}

![AWS console for Application name](/assets/images/screenshots/aws-elastic-beanstalk-revisited/elastic-beanstalk-dashboard-deployed@2x.png){: .screenshot .big}
