# PTTP AWS Infrastructure

## Adding a new environment

Current environments for PTTP are:
- development
- pre-production
- production

To create a new environment, Terraform first needs to be bootstrapped with a state file bucket.

Run:
`make bootstrap`

You'll be prompted for the environment name, which will be interpolated into the state file bucket name.
