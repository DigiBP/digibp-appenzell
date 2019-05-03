# DigiBP Group Appenzell - Unemployment Insurance Registration

This repository contains a registration workflow for unemployement insurance running on Camunda BPM. This repository is part of the group assignment of the Digitalization of the Business Processes (SS19) Module at the FHNW. Check out our Presentation Slides to get an overview of the process as well as the tools and technologies used.

Authors:

Stefan Eggenschwiler, stefan.eggenschwiler@students.fhnw.ch <br>
Isabelle Ribeiro Büchli, isabelle.ribeiro@students.fhnw.ch <br>
Nadine Kleger, nadine.kleger@students.fhnw.ch <br>
Rafael Ochoa, rafaelangel.ochoagalindez@students.fhnw.ch <br>
Xiaoxia Ming Naef, xiaoxia.mingnaef@students.fhnw.ch <br>

# Methodology and Approach
## Design Approach
After the first lesson, the team was able to sketch the process and execute the first workflow by running the Camunda BPM Engine on Heroku. Although with a limited functionality. Furthermore, documentation and design plans were crafted and some tests were conducted. The continuous development and adaptations of the solution has been treated as sprints and the vast majority of work has been executed in group work with parts split into individual assignments.

## Collaboration
Git Version control was used in order to work collaboratively on the project. GitHub was used for the versioning of the development increments, as well as to create the technical documentation.
In addition, the team worked with Google Drive to make all scripts, files for Camunda and BPMN along with other documentation available immediately to the whole team independing on location and time. 

## Testing
In order to minimalize defects, various functional tests were conducted. The team moved on along the process bit by bit to avoid long searches for errors. 

## Project Management
Tasks were tracked within Google Drive and assigned to the team members. Since the team only consisted of five team members, no designated project leader was chosen. Tasks were taken by the each team member individually.

## Tools and Software
The following tools and software has been used for implementing the incident management process.

| Tool / Software  | Description |
| ---------------- | ------------------ |
| Camunda Modeler  | The Camunda Modeler is used to create BPMN, CMMN and DMN models. The modeler is based on [bpmn.io](http://bpmn.io/).  |
| GitHub| Github is used for collaboration and versioning of the programming code as well as the models. |
|Heroku|Heroku is a PaaS (Platform as a Services) which is used to quickly build, run, and operate the Camunda in the cloud. |
|Zapier|Zapier is a web-based service that allows end users to integrate the web applications.

# Process Description (Application/Registration Unemployment Insurance)
The following chapter describes the basic idea behind the selected process. 

## AS-IS Highlevel Process
1. The unemployed has to report in person to the Regional Employment Centre (REC/RAV) at one of Basel Canton's two locations by no later than the day the person becomes unemployed. REC will provide the unemployed with the necessary forms and informs about how to proceed. 
* An official form of ID is required - for foreign nationals this would be the residence permit or settlement permit. <br>
2. With the received application, the unemployed will receive an appointment for the recording and registration of his/her personal data. <br>
3. Registration of personal data. The following documents are required: 
* An OASI-IV insurance certificate or health insurance card <br>
* Official piece of personal identification <br>
* Residence certificate or a residence confirmation from your commune of residence <br>
* A 'Registration at the commune of residence' form, if initial registration did not take place at a RAV centre <br>
* Foreign nationals must also produce their permanent residence permit or a foreign national identity card <br>
4. After this interview the unemployed will be assigned a personal advisor from the Regional Employment Centre. <br>
5. The personal advisor will provide the unemployed with the necessary support during the job search in regularly scheduled consultations.

## TO-BE Digitalized Process
![](https://github.com/DigiBP/digibp-appenzell/blob/master/ProcessTOBE.PNG)

1. The person affected gets unemployed and reports the state via app to the Regional Employment Centre (REC/RAV).
2. The unemployed can upload the necessary forms right away
* For the registration, a valid Social Security Number (AHV) number is required 
2. The process checks for the latest unemployment date, if any, to determine if the unemployed qualifies for insurance coverage
3. Based on age, gender and insurance coverage the process defines if the registration is eligible and complete
4. If the registration is eligible and complete, the unemployed gets an automized notification via email
5. If the unemployed is not eligible, the process ends here
3. Registration of personal data. The following documents are required: 
* An OASI-IV insurance certificate or health insurance card <br>
* Official piece of personal identification <br>
* Residence certificate or a residence confirmation from your commune of residence <br>
* A 'Registration at the commune of residence' form, if initial registration did not take place at a RAV centre <br>
* Foreign nationals must also produce their permanent residence permit or a foreign national identity card <br>
4. After this interview the unemployed will be assigned a personal advisor from the Regional Employment Centre. <br>
5. The personal advisor will provide the unemployed with the necessary support during the job search in regularly scheduled consultations.

### Phases - Status

| Phase  | Status |
| ---------------- | ------------------ |
| Register new user  | Open  |
| Elegibility process  | In process  |
| Elegible no  | Rejected-----> (inform the user and close the case)  |
| Eligible yes  | Acepted  |
| Request info to Employee  | Pending (for employer info)  |
| Assigned to SW to review  | Pending for approval (by the social worker)  |
| SW review the case  | Approval denied (Inform the user)  |
| SW review the case  | Approved  |
|   | Completed  |
                                                  


## Camunda Processes Step by Step Guide

## Developer Documentation

## Integrations & Interfaces








# DigiBP Camunda Template

[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![Deploy to Heroku](https://img.shields.io/badge/deploy%20to-Heroku-6762a6.svg?longCache=true)](https://heroku.com/deploy)

## Maintainer
- [Digitalisation of Business Processes](https://github.com/digibp)

## License

- [Apache License, Version 2.0](https://github.com/DigiBP/digibp-archetype-camunda-boot/blob/master/LICENSE)
