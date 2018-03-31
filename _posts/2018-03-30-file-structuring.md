---
title: Organize Thy Project
layout: post
date: 2018-03-30 05:00:00 +0000
tag:
- file management
- folder structure
- folder organization
- react
- redux
- feature vs function driven
category: blog
description: Feature driven file organization
---
![file-structuring](/assets/images/posts/file-structuring/file-structuring.png)

* [Introduction](#introduction)
* [Problem](#problem)
* [Guiding Principles](#guiding-principles)
* [Function Driven File Structuring](#function-driven-file-structuring)
* [Domain Driven File Structuring](#domain-driven-file-structuring)
* [Best Of Both Worlds](#best-of-both-worlds)
* [Conclusion](#conclusion)

### Introduction

One of the biggest challenges I discovered during my learning of creating React/Redux apps is how to organize my 
files. `create-react-app` sort of gave me a head start in differentiating between my back-end and front-end code 
(client folder for front-end), but it wasn't enough. 

There are two methods that I tried which were equally effective but one trumped the other based on readability 
and consistency.

**Function Driven**: organizing your files based on each function of the app. Most common type of function 
driven folder structuring is MVC, where you have your models in one folder, views in a different folder and 
controllers in another.

**Domain Driven**: organizing your files based on the domains of your application i.e. having all 
functionality of a task list stay in one directory.

In this blog post, I want discuss the importance of domain driven file structuring over function driven.

### Problem

One of the most common problems I encountered when organizing my files based on functionality is **Shotgun Surgery**. 
Shotgun surgery is when one change leads to making changes in multiple files simultaneously. Just as painful as 
yak shaving. The following sections will explain how to mitigate this problem.

### Guiding Principles

* Things that change together, should stay together.

### Function Driven File Structuring

```
.
└── routes
    ├── Components
    │   ├── AddTaskBar.jsx
    │   └── TaskList.jsx
    ├── Containers
    │   ├── AddTaskBarContainer.jsx
    │   └── TaskListContainer.jsx
    └── Styles
        └── TaskList.css
```
The challenge with the scenario above is that I need to drain more mental energy into connecting the dots and 
figuring out which files need to be simultaneously changed so my app does not break. For instance, my `TaskList.jsx` 
component relies on the `TaskListContainer.jsx` container, therefore I have to consciously know that these files need
 to change simultaneously.

### Domain Driven File Structuring

```
.
└── tasks
    ├── AddTaskBar.jsx
    ├── AddTaskBarContainer.jsx
    ├── TaskList.css
    ├── TaskList.jsx
    └── TaskListContainer.jsx
```

In the example above, I know exactly which files are affected and will change together under a folder titled after the 
domain `tasks`.

### Best Of Both Worlds

It's not completely possible to organize all your files based on the app's domain. There are times when exceptions 
are made at a higher level for the following reasons:
- Differentiating between front-end and back-end code
- Maintaining React and Redux separately

The following is an example of the front-end `src` folder:
```
.
└── src
    ├── index.js
    ├── modules
    │   ├── auth
    │   │   ├── action-creators.js
    │   │   ├── action-types.js
    │   │   ├── authentication.js
    │   │   ├── index.js
    │   │   ├── reducer.js
    │   │   └── sagas.js
    │   ├── tasks
    │   │   ├── action-creators.js
    │   │   ├── action-types.js
    │   │   ├── index.js
    │   │   ├── reducer.js
    │   │   ├── repository.js
    │   │   └── sagas.js
    │   ├── root-reducer.js
    │   └── root-saga.js
    ├── routes
    │   ├── App.jsx
    │   ├── Title.jsx
    │   ├── auth
    │   │   ├── Authentication.jsx
    │   │   └── AuthenticationContainer.jsx
    │   └── tasks
    │       ├── AddTaskBar.jsx
    │       ├── AddTaskBarContainer.jsx
    │       ├── TaskList.css
    │       ├── TaskList.jsx
    │       └── TaskListContainer.jsx
    └── store.js
```

As shown above, my modules (Redux) and routes (React) are maintained separately because they usually don't change 
together once they are wired up.
 
Changes to the Redux code usually does not force any changes to my React code and vice versa. Additionally, all the 
necessary functions of my domain are maintained independently, such as with auth and tasks. Everything that needs to 
change together are maintained within a common folder.

### Conclusion

To read more upon the benefits of combining containers and components together, check out [A Better File Structure 
For React/Redux Applications](https://marmelab.com/blog/2015/12/17/react-directory-structure.html). If you think 
there is even a better method at file structuring, please share below!
