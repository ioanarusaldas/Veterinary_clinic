# Veterinary_clinic
Pentru rulare este nevoie de:
	Microsoft Visual Studio Code
	Microsoft SQL Server Management
	imagine sql de docker(imagine folosita la laborator) -(sudo) docker pull mcr.microsoft.com/mssql/server:2019-latest
1.Pornire docker => docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=parolaAiaPuternic4!" -p 1433:1433 --name sql1 -h sql1 -d mcr.microsoft.com/mssql/server:2019-latest
2. Deschidere proiect in Microsoft Visual Studio Code => Veterinary-clinic.sln 
