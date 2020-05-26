#!/usr/bin/env groovy

// Build Mobile SDK documentation

def nodetype = 'cmake'

// Load User Mapping Library
@Library('sklib@develop')
import org.sk.Users
@Field Users skuser
skuser = Users.newInstance(this)

// Set-up Global Variables for Slack Messaging
import groovy.transform.Field
@Field String slack_default_channel = '#ci'
@Field Map slackColourMap = [ success:'good', failure:'danger', warning:'warning' ]
@Field Map slackmsgtype = [ FAIL:'danger', WARN:'warning', SUCCESS:'good' ]
@Field String slackMsgPrefix = ''
@Field String slackNotifyCommiter = ''
// END: Global Variable Section

properties ([ buildDiscarder( logRotator( artifactNumToKeepStr: '15', daysToKeepStr: '90', numToKeepStr: '30' ) ) ])

node (nodetype) {
   deleteDir()

   tokens = "${env.JOB_NAME}".tokenize('/')
   def decodedRepoName = java.net.URLDecoder.decode(tokens[tokens.size()-2], 'UTF-8')
   def decodedBranchName = java.net.URLDecoder.decode(tokens[tokens.size()-1], 'UTF-8')
   def currentStage = ''

   try {
      stage('start') {
         currentStage = 'Start'
         checkout scm
      }

      def gitCommitShortHash = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%h\'').trim()
      def gitCommitAuthor    = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%an\' | sed \'s/^sk//\'').trim()
      def gitCommitter       = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%cn\' | sed \'s/^sk//\'').trim()
      def gitCommitMsg       = sh(returnStdout: true, script: 'git --no-pager show -s --format=\'%s\'').trim()
      def isGitTag           = sh(returnStdout: true, script: 'echo $([[ "`git describe --exact-match --tags 2>&1`" == *"fatal"* ]] && echo false || echo `git describe --exact-match --tags`)').trim()
      def buildNumber        = sh(returnStdout: true, script: 'echo ${BUILD_URL} | tr \'/\' \' \' | awk \' { print $9 }\'').trim()
      def branch_norm        = decodedBranchName.replace("/","_") 

      if (gitCommitAuthor) {
         gitCommitAuthor = skuser.getSlackName(gitCommitAuthor)
         slackNotifyCommiter = "${gitCommitAuthor}"
      }
      slackMsgPrefix = "*Jenkins Job Report*\n*Repo:* ${decodedRepoName}, " + "*Branch:* ${decodedBranchName}, *Build:* ${BUILD_DISPLAY_NAME} \nCommit: ${gitCommitShortHash} \nCommit Author: @${gitCommitter}"

      stage('compiling') {
         currentStage = 'Checkout source'
         def rubyVersion = '26'
         def gemPathsEnv = [
            "PATH+GEMPATH=/opt/rh/rh-ruby${rubyVersion}/root/usr/bin:/opt/rh/rh-ruby${rubyVersion}/root/usr/local/bin", 
            "LD_LIBRARY_PATH+GEMPATH=/opt/rh/rh-ruby${rubyVersion}/root/usr/lib64:/opt/rh/rh-ruby${rubyVersion}/root/usr/local/lib64"
         ]
         def buildEnv = gemPathsEnv + [
            "decodedBranchName=${decodedBranchName}",
            "ciBuildUrl=${BUILD_URL}","bNumber=${buildNumber}"
         ]
         wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            withEnv(buildEnv) {
               sh "./documentation.sh \"${gitCommitMsg}\""
            }
         }
      }

      def slackMsg = "${slackMsgPrefix}\nBuild & deploy status: *SUCCESS* \nSee Jenkins Output:\n${BUILD_URL} \n Apk available on : \n http://toolchain2.samknows.com/samknows-android-sdk_${branch_norm}_${buildNumber}"
      slackSend channel: slackNotifyCommiter, color: slackmsgtype.SUCCESS, message: slackMsg
      slackSend channel: "#ci-android", color: slackmsgtype.SUCCESS, message: slackMsg

   }
   catch (err) {

	}
}
