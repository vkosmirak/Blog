---
layout: post
title: "Git+Jira"
date: 2015-01-05 10:59
comments: true
categories: 
---

Native Universal Recognote iOS App
===

###Style guides:

Please check [Apple guidelines](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html) and [Ray Wenderlich styleguide](https://github.com/raywenderlich/swift-style-guide).

###Git+Jira workflow

Each task should have appropriate task in jira and must be done in separate branch with naming 'tasks/RCGN-XXXX(Task-title)', for example:

	tasks/RCGN-2304(Recognize-screen-functionality)

After finishing task and pushing work to remote, you must merge your branch with master (to have latest changes), and create Pull Request(PR) [What is it?](https://confluence.atlassian.com/display/BITBUCKET/Work+with+pull+requests) to master

* PR title: JIRA ticket title.
* PR description: what have been actually done in this PR.
* PR reviewers: assign teammates as reviewers. 

Example screenshot with filled PR info:
![Example PR filled info](http://i.imgur.com/fSj6dNE.png)
	
Assigned teammates should review PR and either leave comments what you have to fix or Approve Pull Request by pressing 'Approve' button. You should either answer to commenter with rejection and explanation arguments or fix problem places and push commit to your branch.

After everything is fixed and all teammates approve Pull Request, merge master(team leader) should merge your branch to master.

Workflow: 

1. Create task in JIRA
2. Set status in-progress
3. Create corresponding branch and push it to remote
4. Start working
5. Finish working, push to remote
6. Merge with master, re-assure that everything is working
7. Create pull request
8. Fix comments if any
9. If everyone approve PR -> merge master merge it to master

###Setting up CocoaPods

Read installing and configuration instructions [here](http://guides.cocoapods.org/using/getting-started.html).
 
Always open project from Recognote.xcworkspace, don't use Recognote.xcodeproj.

When dependencies are updated or any time when you have problems with dependencies not found or dependencies failing to build, run

>pod update

this will update the dependencies and their build settings. Then try to build again.