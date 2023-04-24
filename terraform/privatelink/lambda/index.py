import boto3

SESSION = boto3.session.Session()
ORG = SESSION.client("organizations")
EC2 = SESSION.client("ec2")


def get_org_accounts(**args):
    response = ORG.list_accounts(**args)
    accounts = response["Accounts"]
    if "NextToken" in response:
        accounts += get_org_accounts(NextToken=response["NextToken"])
    return accounts


def get_vpc_endpoint_requests(**args):
    args["Filters"] = [
        {
            "Name": "vpc-endpoint-state",
            "Values": [
                "pendingAcceptance",
            ],
        },
    ]
    response = EC2.describe_vpc_endpoint_connections(**args)
    vpcEndpointConnections = response["VpcEndpointConnections"]
    if "NextToken" in response:
        args["NextToken"] = response["NextToken"]
        vpcEndpointConnections += get_vpc_endpoint_requests(**args)
    return vpcEndpointConnections


def splat_map(list_of_reqs):
    output = dict()
    for item in list_of_reqs:
        if item["ServiceId"] not in output.keys():
            output[item["ServiceId"]] = []
        output[item["ServiceId"]].append(item["VpcEndpointId"])
    return output


def lambda_handler(event, context):
    accountids = list(map(lambda x: x["Id"], get_org_accounts()))
    toapprove = list(
        filter(
            lambda x: (x["VpcEndpointOwner"] in accountids),
            get_vpc_endpoint_requests(),
        )
    )
    if len(toapprove) > 0:
        splat = splat_map(toapprove)
        for key in list(splat.keys()):
            accept = EC2.accept_vpc_endpoint_connections(
                ServiceId=key, VpcEndpointIds=splat[key]
            )
            if len(accept["Unsuccessful"]) > 0:
                print("Error accepting connection: {}".format(accept))
    return True
