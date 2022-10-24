# Responsible student simulator
### Author:  Patryk Nikonowicz
### Date: 2022-10-24

<br />
<a name="readme-top"></a>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li> 
    <li><a href="#user-stories">User stories</a></li>

  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Responsible student simulator will be a mix between calendar and TO-DO list. In this application user will be able to insert long tasks that require many hours over a long period of time to complete, like finishing a project or studying for an exam. In order to avoid last minute all nighters application will create entries in calendar and send notifications to help monitor progress made on all of these tasks.

Application can be connected to google calendar API to create events and reminders. It will also generate notifications at appriopriate times.

Example use case: 

User has a big project with a deadline in a month. User makes a guess that a project will take about 20 hours to complete. User feeds the data to the application. Application then creates reminders to make steady progress of about 5 hours each week. User can insert how much work has already been done and whether the estimated amount of work-hours changed. If no progress is made the application sends notifications growing in intensity.





<!-- GETTING STARTED -->
## User stories
Here are user stories



| Epic     | User story |     Acceptance criteria |
| ---      | ---        | ---                     |
| <p> As user i want to be able to log in to my account so that i can synchronize my data among multiple devices.<p>|  <p> As user I need to be able to log in using identity provider of choice (google/facebook).</p> | <ul><li> User can successfully log in and stay logged in.</li> </ul>| 
| | <p> As user I need to be able to log out of application.</p>| <ul><li> User can log off and log in and prevent data from leaking to another account.</li></ul>|
| As user I want to manage tasks with assigned name, amount of hours required to complete it and a deadline. | As user I need to create new task with name, deadline and amount hours required. | <ul><li> User can successfully create a task and store it locally/remotely.</li> <li>Process is user-friendly.</li>|
| | As user i need to be able to modify existing task. I need to change amount of hours spent on task each day.| <ul><li>User can modify the data and all modifications will be reflected in notifications and/or calendar.</li><li>User can view and modify amount of hours already spend on task.</li></ul> |
| | As user I need to be able to delete task. | <ul><li> User can delete the task and related notifications/calendar entries. </li></ul>|
|As user I want to be able to manage notifications for each of my tasks.| As user I need to enable/disable notifications/calendar entries of my tasks.|<ul><li>User can enable/disable calendar entries for tasks. These entries should update based on task that user is tracking.</li><li> User can enable/disable application notifications for each task.</li></ul>  |
||As user I need to modify intensity of notification/calendar entries.| <ul> <li>User can modify how often notifications should be sent to user.</li><li>Notifications react to changes.</li></ul>|