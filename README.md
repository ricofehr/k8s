# k8s

A base k8s install with Vagrant (Bento/Ubuntu boxes)
- 3 sizings
  - small: 1 Master and 2 Nodes (fit to 16Go RAM Laptop with 2 cpu cores)
  - medium : 1 Master and 3 Nodes (fit to 24Go RAM Laptop with 4 cpu cores)
  - large : 1 Master and 5 Nodes (fit to 32Go RAM Laptop with 6 cpu cores)
- CI Tools : gitea, sonar, jenkinsx, docker-registry
- Monitoring tools and logging (wip)
- Istio implementation (wip)

## The cluster

The k8s cluster installed by Ansible on Local with Vagrant
![k8s cluster](https://github.com/ricofehr/k8s/raw/master/k8s-cluster.png)

## Run

```
$ git submodule update --init
$ up
```

Once setup done
- Dashboard is reached here
http://192.168.78.10:8001/api/v1/namespaces/kube-system/services/http:dashboard-kubernetes-dashboard:http/proxy/

## Options

```
Usage: ./up [options]
-h           this is some help text.
-d           destroy all previously provisioned vms
-s xxxx      sizing deployment, default is small
              - small : 1 master and 2 nodes, host with 16Go ram / 2 cores
              - medium : 1 master and 3 nodes host with 24Go ram / 4 cores
              - large : 1 master and 5 nodes, host with 32Go ram / 6 cores
```

## Openstack deployment

An openstack deployment is setted with Terraform, use 'deployos' script for managed this
```
Usage: ./deployos [options]
-h           this is some help text.
-a xxxx      openstack auth url, default is http://172.29.236.101:5000/v3
-u xxxx      openstack user, default is tenant0
-p xxxx      openstack password, default is tenant0
-t xxxx      openstack tenant, default is tenant0
-r xxxx      openstack region, default is RegionOne
-s xxxx      deployment sizing, choices are small / medium / large, default is small
-fm xxxx     openstack flavor for master instance, default is large
-fn xxxx     openstack flavor for nodes instance, default is xlarge
-fip xxxx    openstack floatingip network id, no default
-oscrt xxxx  openstack ssl certificate path
-secgrp xxxx      openstack tenant security group, default is k8s
-snet xxxx   openstack subnet id, no default
-o xxxx      openstack operating system image, default is bionic
-k xxxx      public rsa key path, default is ~/.ssh/id_rsa.pub
```
Default values are defined following openstack deployment with the repo https://github.com/ricofehr/os-ansible-poc

Once installed, the terraform folder is into tf/openstack, for example destroy the k8s deployment
```
cd tf/openstack && terraform destroy
```
