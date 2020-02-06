#!/usr/bin/env bash
# custom aws functions since awscli is terrible.
# use `type aws_blah_blah` to get the command that is running
# also, aws-shell is less terrible, use that if you have to.


#################AWS SNS###################
aws_sns_sendsms(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]] || [[ -z ${2} ]]; then
        echo "example: awssms 11235551234 'some message'"
    else
        aws sns publish --phone-number ${1} --message "${2}"
    fi
}

#################AWS EC2###################
aws_ec2_list(){
    all_ec2_regions=$(aws ec2 describe-regions --query Regions[*].[RegionName] --output text)
    for region in $all_ec2_regions; do 
        aws ec2 describe-instances \
            --region $region \
            --query "Reservations[*].Instances[*].{Zone:Placement.AvailabilityZone, InstanceID:InstanceId, State:State.Name, Type:InstanceType, Key:KeyName, IP:PublicIpAddress, Name: Tags[0].Value}" \
            --output table
    done
}
aws_ec2_delete(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]] || [[ -z ${2} ]]; then
        echo "Deletes the specified instance-id in the region you specify"
        echo 'example: aws_ec2_delete i-0c881632e54d6394d us-east-1'
    else
        aws ec2 terminate-instances \
            --instance-ids ${1}\
            --region ${2}\
            --output table
    fi
}
#aws_ec2_create

#################AWS R53###################
aws_route53_list(){
    aws route53 list-hosted-zones  \
        --query HostedZones[*].{Name:Name} \
        --output table
}


#################AWS Lightsail###################
aws_lightsail_list(){
    all_lightsail_regions=$(aws lightsail get-regions --query regions[*].[name] --output text)
    for region in $all_lightsail_regions; do
        aws lightsail get-instances \
            --region $region\
            --query "instances[*].{Zone:location.availabilityZone, IP:publicIpAddress, Username:username, State:state.name, key:sshKeyName, BundleID:bundleId, Name:name}" \
            --output table
    done
}

aws_lightsail_create(){
#get list of blueprints via: 
#   aws lightsail get-blueprints --query "blueprints[*].[blueprintId]"
#get a list of bundleids via:
#   aws lightsail get-bundles --query="bundles[*].{ID:bundleId, CPUs:cpuCount, Disk:diskSizeInGb, Ram:ramSizeInGb, Cost:price}"
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]] || [[ -z ${2} ]]; then
        echo "Creates a medium sized debian 9.5 instance in us-east-1a"
        echo "example: aws_lightsail_create jimmyslightsailinstance MyKeynameOnAWS"
    else
        aws lightsail create-instances \
            --bundle-id medium_2_0 \
            --blueprint-id debian_9_5 \
            --instance-names ${1} \
            --availability-zone us-east-1a \
            --key-pair-name ${2}\
            --output table
    fi
}

aws_lightsail_get_port_states(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]]; then
        echo "Usage: aws_lightsail_get_port_states <LightsailInstanceName>"
    else
        aws lightsail get-instance-port-states --instance-name ${1}
    fi
}

aws_lightsail_delete(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]]; then
        echo example: aws_lightsail_delete jimmyslightsailinstance
    else
        aws lightsail delete-instance \
            --instance-name ${1}\
            --output table
    fi
}

aws_lightsail_getkeynames(){
    aws lightsail get-key-pairs \
        --query="keyPairs[*][name]"
}


#################AWS S3###################
aws_s3_list(){
    aws s3api list-buckets \
        --query="Buckets[*]" \
        --output=table
}

aws_s3_create_bucket(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]] || [[ -z ${2} ]]; then
        echo "Usage: aws_s3_create_bucket <bucketName> <private|public-read|public-read-write|authenticated-read>"
        echo "Example: aws_s3_create_bucket jimmysfileshare public-read"
    else
        aws s3api create-bucket \
            --bucket ${1} \
            --acl ${2} \
            --output table
    fi
}

aws_s3_delete_bucket(){
    if [[ ${1} = '-h' ]] || [[ ${1} = '--help' ]] || [[ -z ${1} ]]; then
        echo "Usage: aws_s3_delete_bucket <bucketName>"
        echo "Example: aws_s3_delete_bucket jimmysfileshare"
    else
        aws s3api delete-bucket \
            --bucket ${1}\
            --output table
    fi
}