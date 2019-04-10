    pipeline {
        options {
            buildDiscarder(logRotator(numToKeepStr: '2'))
            }
        triggers {
        cron('H * * * *')
        }

    agent {
            kubernetes {
                label 'terraform-builder'
                defaultContainer 'jnlp'
                yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: terraform-builder
  annotations:
    iam.amazonaws.com/role: jenkins
spec:
  containers:
  - name: terraform
    image: hashicorp/terraform:0.11.3
    command:
    - cat
    tty: true
"""
            }
        }

    stages {

        stage('TF Fmt') {
        steps {
            container('terraform') {
            sh 'apk add --no-cache bash'
            sh '''#!/usr/bin/env bash
                set -e
                terraform init
                files=$(git diff --cached --name-only HEAD~1)
                for f in $files
                do
                if [ -e "$f" ] && [[ $f == *.tf ]]; then
                    terraform fmt $f
                fi
                done
                '''
            }
        }
        }
        stage('TF Validate') {
        steps {
            container('terraform') {
                sh '''#!/usr/bin/env bash
                    set -e
                    files=$(git diff --cached --name-only HEAD~1)
                    for f in $files
                    do
                    if [ -e "$f" ] && [[ $f == *.tf ]]; then
                        AWS_REGION=eu-west-2 terraform validate --var 'aws_account_id=0000000' --var 'aws_region=eu-west-2' --var 'users=["sage"]' .
                        git add $f
                    fi
                    done
                    '''
                }
            }
        }
    }
}
