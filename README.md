# tfsample
This is a terraform sample code, which deploy aws environment like this image.<br>
for detail, please read the code...

![image](https://github.com/j-un/tfsample/raw/master/tfsample.png)

## Prerequisite Tasks
* The basic knowledge about terraform(what's this, installing, usage, etc.) please refer to the official document.<br>
https://www.terraform.io/intro/

* Create 'terraform.tfvars' file, and add your credentials.
```
$ cat terraform.tfvars
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
```

* replace this line with your IP address.
```
$ grep -n replace base.tf
31:        cidr_blocks = ["xx.xx.xx.xx/32"]  # replace with your IP address.
```

* replace this line with your aws key pair name.
```
$ grep -n replace service1.tf
27:    key_name = "key-name"    # replace with your key name.
44:    key_name = "key-name"    # replace with your key name.
```
