# serverShephard
linux (redHat) shell script to herd server details, report to a local .txt file

## Description
There is a need to ssh to a number of servers, and pull a harvest some server details.
Details needed including: which ports are being listened to, which app is bound to ports, application details

## Getting Started

This shell script is written for a redHat specific deployment. Syntax for some commands written in ./serverHerder_*.sh may need to be adapted to the env for other deployment.
>Note: sudo as root on server before running the script
>Note: chmod +x <script>.sh will need to be run prior to each run to allow execute from shell permissions on the sh file deployed

### Prerequisites

No dependencies or libraries. See getting started for modifications required for other deployments

## Deployment

Copy the shell script to the server running some deployment.

## Releases
### Version 1.1
  - functional and tested with QA data
  - ready for readHat deployment
  - writes to a test file in the output directory
