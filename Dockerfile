FROM nginx:latest

RUN sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list
RUN sed -i 's#http://security.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list
RUN rm -Rf /var/lib/apt/lists/* && apt-get update
RUN apt-get install -y git
RUN git init --bare ~/blogs.git
RUN mkdir -p /var/www/hexo
RUN echo "git --work-tree=/var/www/hexo --git-dir=/root/blogs.git checkout -f" >~/blogs.git/hooks/post-receive
RUN chmod a+x ~/blogs.git/hooks/post-receive
RUN apt-get install -y openssh-server
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -y
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -y
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -y

#Add Nginx Files
ADD nginx/hexo.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 22
EXPOSE 80

# Next Step
# RUN mkdir ~/.ssh
# RUN echo "***" > ~/.ssh/authorized_keys
# RUN chmod 600 ~/.ssh/authorized_keys
# RUN chmod 700 ~/.ssh
# RUN mkdir /run/sshd
# RUN /usr/sbin/sshd
