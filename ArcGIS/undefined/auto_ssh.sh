# NO_PWD_SSH
#!/bin/sh
IP_1=10.10.20.38,10.10.20.39,10.10.20.40
PWD_1=hadoop@123
USER_1=hadoop

key_generate() {
    expect -c "set timeout -1;
        spawn ssh-keygen -t dsa;
        expect {
            {Enter file in which to save the key*} {send -- \r;exp_continue}
            {Enter passphrase*} {send -- \r;exp_continue}
            {Enter same passphrase again:} {send -- \r;exp_continue}
            {Overwrite (y/n)*} {send -- n\r;exp_continue}
            eof             {exit 0;}
    };"
}

auto_ssh_copy_id () {
    expect -c "set timeout -1;
        spawn ssh-copy-id -i $HOME/.ssh/id_dsa.pub $1@$2;
            expect {
                {Are you sure you want to continue connecting *} {send -- yes\r;exp_continue;}
                {*password:} {send -- $3\r;exp_continue;}
                eof {exit 0;}
            };"
}

rm -rf ~/.ssh

key_generate

ips_1=$(echo $IP_1 | tr ',' ' ')
for ip in $ips_1
do
    auto_ssh_copy_id $USER_1 $ip  $PWD_1
done

eval &(ssh-agent)
ssh-add

