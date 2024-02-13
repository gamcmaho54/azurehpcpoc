# Azure HPC PoC
<br>
<br>
![GitHub Image](/images/azureHpcPoc.jpg)
<br>
<br>
Clone the repo to your local device<br>
Modify the parameters.json<br>
Deploy to Azure by running, az deployment sub create --name hpcPocDeploy --location <region> --template-file main.bicep --parameters parameters.json<br><br>
Remember to define your chosen region in the az deployment command above
