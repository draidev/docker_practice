FROM centos:7.9.2009

#서버 시간 설정
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#서버 홈폴더 설정
RUN mkdir /home/jenkins

#서버 yum update 및 openjdk 설치
RUN yum update -y && yum install epel-release java-11-openjdk-devel -y 

#tomcat+jenkins 압축 파일 복사
COPY apache-tomcat-9.0.8-pre-install.tar.gz /home/jenkins/apache-tomcat-9.0.8.tar.gz

#압축 해제
RUN cd /home/jenkins && tar -zxvf apache-tomcat-9.0.8.tar.gz

#서비스 포트 지정
EXPOSE 80

#작업 폴더 설정
WORKDIR /home/jenkins

#Tomcat 서비스 시작
CMD ["/home/jenkins/apache-tomcat-9.0.8/bin/catalina.sh", "run"]
