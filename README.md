# Workflow Dependency Manager

## Description
This app will help you create a graphical visulaisation of all the Workflow/Jobs running in your system along with downstream dependency.

Lets assume you have a sample dependency data as attached and you want to visualize the dependency with real time application running status:

<img width="1153" alt="image" src="https://github.com/user-attachments/assets/8d386edf-6db9-406f-b7ef-4b7a4cb42e14" />

<img width="807" alt="image" src="https://github.com/user-attachments/assets/9be74e7f-93da-411a-be8e-c5487205b605" />

 
So this repo will help you to create this visualisation.

## Setup guide

For this use case we are using mysql to store the metadata information

For initial table setup refer **wf-dependency-manager/backend/tree-script.sql**
Use **setup-instructions.txt** from the repo to setup the application to run from local.
Use **setup-instructions-docker.md** to run the application on a docker.

once you do the setup and initialize the application you will see output application like below:
<img width="1714" alt="image" src="https://github.com/user-attachments/assets/00b7528f-f0c7-4669-84b9-96c56145c11b" />
