# Decision Document

## Table of Contents
* [Reasoning](#reasoning)
* [Disclaimer](#disclaimer)
* [Solutions](#solutions)
    * [Submission](#submission)
        * [Technologies](#submission-technologies)
        * [Explanation](#submission-explanation)
        * [Cost](#submission-cost)
    * [Alternative](#alternative)
        * [Technologies](#alternative-technologies)
        * [Explanation](#alternative-explanation)
        * [Cost](#alternative-cost)

## Reasoning
I am addressing this challenge from the standpoint of trying to achieve the greatest success
for DynamicEnablement. As I am a member of this team my goals are reducing complexity were 
reasonable and reducing cost while maintaining or increasing the scalability. The reason I 
target these metrics is two fold. First, the reduction in complexity helps dev team manage 
the project without getting lost in the details. Second, the reduction in cost helps the
company itself and could lead to more new hires down the road. 

## Disclaimer
So with that said, based on the complete solution requirements from the [readme](README.md) my
solution you see in repo may disqualify me. I have included a [diagram](alternative-architecture.png)
of the alternative solution that would check all the boxes, but would fail at my first two goals. 

## Solutions
Both solutions utilise AWS infrastructure

### Submission

#### Submission Technologies
* CloudFormation (Infra CD)
* CodePipeline
* CodeBuild (Code CD)
* CloudFront (Code Distribution)
* S3 (Code Storage)
* Route53 (DNS) (not implemented due to cost)
* Certificate Manager (SLL/TLS) (not implemented, requires route53)
* Bash (run infra deployment)
    * `sam deploy` instead of `aws cloudformation *` to reduce further on complexity
* GitHub (Everything CI)

#### Submission Explanation
This approach leverages aws to manage all the scalability for the application as it is today.
There is only one html file and thus this could be statically accessed as it is being done by
using Nginx as the base image. 

With that said, no monitoring or SLI/SLO has been included. AWS
provides SLA on the service up time, thus if the configuration is correct and a problem occurs
one would only need to reach out to Support to determine the issue. A solution could be had where
we monitor the AWS services page and create notifications with SNS for any resource that we use 
in a particular region went down. 

The compelling reasons not to are more development work, more infra as now we need some compute 
resources, increased complexity, increased cost, and little benefit as each resource in this 
solution for runtime is not region specific with an underlying architecture that is redundant.

#### Submission Cost
The total cost of this solution for all time is $1 per month so long as the project stays within the
usage limits for the free tier items. Given the size of the project, this should be maintainable for
some time.

* CloudFormation up to 1000 operations
* CodePipeline up to one active pipeline
* CodeBuild up to 100 minutes of build time
* CloudFront up to 50 GB of data transfer out
* S3 up to 5 GB storage
* [Route53](https://aws.amazon.com/route53/pricing/) est $1
* Certificate Manager free with use of aws resources
* Bash free with use of any operating system
* GitHub free until you want more features

### Alternative

#### Alternative Technologies
* CloudFormation (Infra and Container CD)
* CodePipeline
* CodeBuild (Image CD)
* CodeDeploy (Container CD)
* Docker (Code distribution and runtime)
* ECR (Image Repository)
* ECS (Container Orchestration)
* Fargate (Host)
    * ECS + Fargate is the AWS equivalent of GCP Cloud Run
* Application LoadBalancer (Traffic Routing)
* WAF (Initial Protection)
* Networking
    * VPC
    * Subnets
    * Routing Tables
    * NAT (for creating private subnets)
    * Internet Gateway
    * Security Group
* Route53 (DNS)
* Certificate Manager (SLL/TLS)
* CloudWatch (log aggregator, metrics, alerts)
* SNS (notifications)
* EC2 (Bastion Host for accessing infra in private subnets)
* AutoScaling (For reduced downtime of EC2's)
* Elastic Ip (For maintaining public ip's)
* Bash (run infra deployment)
    * `sam deploy` instead of `aws cloudformation *` to reduce on complexity
* GitHub (Everything CI)

#### Alternative Explanation
This approach assumes the company is adamant about using containers for their solution regardless
of the fit for the system they have. It requires the inclusion of creating health checks for 
scalability and appropriate traffic routing. CloudWatch becomes the cornerstone for this cloud native
architecture. Without it or a suitable replacement like ELK (more complex) the system would become
difficult to manage. This includes catching errors in the various components and monitoring for 
potential attacks. 

Because we now are using compute resources, all the resources surrounding networking and the network
security require creating. It would be difficult for a team of the size I imagine would be working
on an application of this size to handle. They could adopt a strategy where we eliminate the container
orchestration and focus on a single container deployment on one EC2 instance. That would remove the 
need for a load balancer, ECS, and the bastion server, but would add the management of the security
on a virtualized server and lose the WAF and private routing of host. So there would be tradeoffs 
that would need discussing with the team to determine what risks they are more comfortable dealing with. 

Should they choose the EC2 route, it is reasonable to believe they would eventually want to move to 
some kind of container orchestration to offload the scaling to an underlying system. Kubernetes used 
with EKS would be an alternative to ECS at that point, but that adds yet another level of complexity 
and security concerns based on the size of the project. 

#### Alternative Cost
The total cost of this solution would be variable. At the least it would estimate $91.10 per month so 
long as the project stays within the usage limits for the free tier items. This would be reduced down
to $54.10 if going with the EC2 option.

* CloudFormation up to 1000 operations
* CodePipeline up to one active pipeline
* CodeBuild up to 100 minutes of build time
* [Code Deploy](https://aws.amazon.com/waf/pricing/)
* Docker up to 200 pulls
* [ECR](https://aws.amazon.com/ecr/pricing/) est $0.10
* ECS included with use of fargate
* [Fargate](https://aws.amazon.com/fargate/pricing/?nc=sn&loc=2) est $16
* [Application LoadBalancer](https://aws.amazon.com/elasticloadbalancing/pricing/?nc=sn&loc=3) est $17
* [WAF](https://aws.amazon.com/waf/pricing/) est $20
* Networking
    * VPC free for the use case
    * Subnets included with VPC
    * Routing Tables included with VPC
    * [NAT](https://aws.amazon.com/vpc/pricing/) est $33
    * Internet Gateway included with VPC
    * Security Group included with VPC
* [Route53](https://aws.amazon.com/route53/pricing/) est $1
* Certificate Manager free with use of aws resources
* CloudWatch free for our use case
* SNS up to 1 mil notifications
* [EC2](https://aws.amazon.com/ecr/pricing/) est $4
* Bash free with use of any operating system
* GitHub free until you want more features
