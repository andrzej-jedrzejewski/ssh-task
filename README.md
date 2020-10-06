## Repository Description

Repository contains script that can be run within docker. The script allows you to connect to specific server from the inventory file.

## How to use the solution?

#### Step # 1:
Get ssh keys from DevOps team and put them in your local repository directory, next to the Dockerfile:


#### Step # 2:
Build docker image and run docker to connect to servers from inventory

```bash
docker build --tag ajsshclient:latest . 
```
```bash
docker run -it ajsshclient:latest serverName
```

where serverName is the name of the server from the inventory e.g.:
```bash
docker run -it ajsshclient:latest server6
```


### Test environment
Test environment was build within terraform in AWS with one bastion and three backend server:
https://github.com/andrzej-jedrzejewski/terraform-ssh-client-poc


### Question 1
Assuming the login username to all servers is ubuntu and we have public key authentication
(your public key is already on all of those hosts), how would you log in to a server?

If ssh keys were added properly to the server:

If you use old version of openssh:
```bash
ssh ubuntu@SERVERIP -o ProxyCommand="ssh -W %h:%p ubuntu@BASTIONIP" 
```

If you use new version of openssh>=7.4:
```bash
ssh -J USERNAME@BASTIONIP USERNAME@SERVERIP
```

### Question 2
There can be thousands of servers in the inventory. You might need to log in remotely multiple
times per hour to arbitrary servers from the list. How would you ease this process?

If I have to login to do some system/application configuration on the thousands of servers
I would think about converting provided inventory to the ansible inventory and generating ~/.ssh/config file with mapping through bastions e.g.:
 ```bash
Host Bastion
  HostName 3.126.210.69
  User ubuntu
  IdentityFile ~/.ssh/bastion.pem

Host server1
  HostName 192.168.134.49
  User ubuntu
  ProxyJump ubuntu@Bastion
  IdentityFile ~/.ssh/backend1_private_key.pem

Host server2
   HostName 192.168.138.178
   User ubuntu
   ProxyJump ubuntu@Bastion
   IdentityFile ~/.ssh/backend1_private_key.pem
```

If there is no option to use ansible I would go with some python/go.

