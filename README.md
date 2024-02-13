# Azure HPC PoC
Clone the repo to your local device by running:<br><br>git clone https://github.com/gamcmaho54/azurehpcpoc.git<br><br><br>
Modify the parameters.json to define Region, VM sizes and Trusted Source IP<br><br><br>
Deploy to Azure by running:<br><br>az deployment sub create --name hpcPocDeploy --location region --template-file main.bicep --parameters parameters.json<br><br><br>
Nb. Remember to  define your chosen region in the command above<br><br>
Nb2. The deployment should complete inside of 10 minutes
