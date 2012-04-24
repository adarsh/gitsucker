This is my response to a coding challenge. Below is the problem definition.


Gitsucker
=========

There once was a developer who started a company. As the company grew he had to
find more and more like-minded engineers to join his mission to change the
world. Being a technologist at heart, he thought the best place to find these
types of engineers is where they live and breath - github. He started by
manually mining through profiles and projects to find the best engineers. Being
a lazy engineer, he decided to automate this mundane task in a tool he called
gitsucker.  Here is a description of how he'd like the tool to work.

1. Type in gitsucker <project_name> (eg. gitsucker backbone)
2. Find the git repo and all the github members who forked the project
3. Ranks the list of the github members found above based on the following
criteria. The higher each one numbers are the better fit they would be.
 * number of original projects they've authored
 * number of ruby or javascript projects they have authored or forked
 * number of orignal or forked projects they have
4. Output the information in a format that makes it easy to accomplish the task
described above.
