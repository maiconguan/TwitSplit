# TwitSplit
<p align="center" >
<img src="logo.jpg" title="TwitSplit logo" float=left>
</p>

The product Tweeter allows users to post short messages limited to 50 characters each.
Sometimes, users get excited and write messages longer than 50 characters.
Instead of rejecting these messages, we would like to add a new feature that will split the message into parts and send multiple messages on the user's behalf, all of them meeting the 50 character requirement.
Example
Suppose the user wants to send the following message:
"I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
This is 91 characters excluding the surrounding quotes. When the user presses send, it will send the following messages:
"1/2 I can't believe Tweeter now supports chunking" "2/2 my messages, so I don't have to do it myself."
Each message is now 49 characters, each within the allowed limit.


## Features

- [x] An application that serves the Tweeter interface.
- [x] Allow the user to input and send messages.
- [x] Display the user's messages.
- [x] If a user's input is greater than 50 characters, split it into chunks that
each is less than or equal to 50 characters and post each chunk as a separate message.
- [x] Messages will only be split on whitespace. If the message contains a span of non-whitespace characters longer than 50 characters, display an error.
- [x] Split messages will have a "part indicator" appended to the beginning of each section.

## Requirements

- iOS 9.1 or later
- Xcode 8.3 or later

## Getting Started

- Read this Readme doc
- Try the apllication by downloading the project from Github at [here](https://github.com/maiconguan/TwitSplit.git)

## Communication

- If you **need help**/**ask a general question**/**found a bug**/**have a feature request**/**want to contribute**, please contact me via email: maiconguan@gmail.com

## Build Project

At this point your workspace should build without error. If you are having problem, post to the Issue and the
community can help you solve it.

## Author
- [Mai Cong Uan](https://github.com/maiconguan)

