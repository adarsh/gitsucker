This is my response to a coding challenge. Below is the problem definition.


Gitsucker
=========

There once was a developer who started a company. As the company grew he had to
find more and more like-minded engineers to join his mission to change the
world. Being a technologist at heart, he thought the best place to find these
types of engineers is where they live and breath - Github. He started by
manually mining through profiles and projects to find the best engineers. Being
a lazy engineer, he decided to automate this mundane task in a tool he called
gitsucker.  Here is a description of how he'd like the tool to work:

1. Type in gitsucker <project_name> (e.g. `gitsucker backbone`)
2. Find the git repo and all the Github users who forked the project
3. Output statistics on each user including:
 * Number of original projects authored
 * Number of forked projects
 * Number of Ruby and JavaScript projects (either authored or forked)
4. Rank the list of Github members returned based on the statistics (you decide
how to weigh the inputs)
5. Output the information in a format that is easy to read
