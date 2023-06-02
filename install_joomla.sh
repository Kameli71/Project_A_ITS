
#!/bin/bash
yum -y update
yum -y install epel-release
yum install -y python3 git
if [ $1 == "master" ]
then

  # install Joomla
  wget https://downloads.joomla.org/cms/joomla4/4-3-2/Joomla_4-3-2-Stable-Full_Package.zip?format=zip -P /Joomla
  apt-get install unzip
  unzip /Users/user11/Desktop/Projet-A/vagrant/Joomla_4-3-2-Stable-Full_Package.zip /Users/user11/Desktop/Projet-A/vagrant/Joomla
  cd /Desktop/Projet-A/Joomla
  # /usr/local/bin/pip3 install Joomla.zip
  yum install -y sshpass
  
  # Install zsh if needed
if [[ !(-z "$ENABLE_ZSH")  &&  ($ENABLE_ZSH == "true") ]]
    then
      echo "We are going to install zsh"
      sudo yum -y install zsh git
      echo "vagrant" | chsh -s /bin/zsh vagrant
      su - vagrant  -c  'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
      su - vagrant  -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
      sed -i 's/^plugins=/#&/' /home/vagrant/.zshrc
      echo "plugins=(git  colored-man-pages aliases copyfile  copypath zsh-syntax-highlighting jsontools)" >> /home/vagrant/.zshrc
      sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g"  /home/vagrant/.zshrc
    else
      echo "The zsh is not installed on this server"
  fi

fi
echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"