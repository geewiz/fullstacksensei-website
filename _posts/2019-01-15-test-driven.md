---
layout: post
title: "Test-Driven"
tags: ["development"]
excerpt: "Why TDD is an investment that pays off"
---

The concept of Test-Driven Development (TDD) isn't particularly new anymore. But even after quite a few years of accompanying my code (regardless if it's a Rails app or Chef infra code) with tests, TDD is still far from being second nature to me. I've recently watched a talk from RubyHACK 2018 which motivated me to get better at it.

![Some Truths About Some Lies About Testing](https://www.youtube.com/watch?v=TkbkCzwg6b8)

In his talk "Some Truths About Some Lies About Testing", David Brady explains why so many of us find it hard to start with building tests first and implementing the actual business logic second: Most of us learned programming in a way that immediately tackled the implementation. Actually, that's how we've learned problem-solving in general: take a problem, break it down into manageable chunks and build up the solution piece by piece. In the end, the solution will deliver the desired outcome. Or maybe it won't, and this is the time when we start testing to find out which of our pieces doesn't behave the way it's supposed to.

In his talk, David calls this approach "Test-After-Development" (TAD) or "Q3 Development", because _knowing the implementation but not what exactly the desired behaviour looks like_ is quadrant III between the two axes "Behaviour known/unknown" and "Implementation known/unknown".

* Quadrant I: Behaviour known, Implementation known
* Quadrant II: Behaviour known, Implementation unknown
* Quadrant III: Behaviour unknown, Implementation known
* Quadrant IV: Behaviour unknown, Implementation unknown

It's quite obvious that Test-Driven Development is generally quadrant II: I've clearly defined the behaviour I want and am working out the implementation.

David also has a good explanation why I often have to force myself to spend effort on building tests at least _for my implementation_ if not _before my implementation_. TAD gives you instant gratification. You see your code doing something that brings you closer, if not full way to the solution. The problem is that this development approach may start easy but gets harder as your codebase grows. David mentions how a change that resulted in a single line of code took them almost two days to implement.

TDD, however, pays off sometime in the future. Granted, it starts hard but it gets easier over time as you can more and more rely on your tests guiding you.

When I have tests, I can make changes if not more efficiently, then at least with much more confidence that I won't accidentally break things. Compared to the pain of untangling code that seemed completely unrelated to my latest change but suddenly started behaving strangely nonetheless, the time spent building tests is a so much better investment. And the experience of deploying code with peace of mind every day is enough of a reason for me to move into quadrant II, step by step.

Watch David's talk, I found it both entertaining and inspiring!
