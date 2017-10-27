PROC IMPORT OUT= WORK.Y 
DATAFILE= "D:\Users\brong\Desktop\group13.csv" 
DBMS=CSV REPLACE; 
GETNAMES=YES; 
DATAROW=2; 
RUN;
/* Proc Corr procedure is usually used for finding the correlation between varibles.*/ 
proc corr data=y; 
var E1 E2 E3 E4 E5; 
run; 
proc corr data=y; 
var G1 G2 G3 G4 G5 G6 G7 G8 G9 G10; 
run; 
proc transreg data=y ss2 detail; 
model BoxCox(DV\lambda=-3 to 3 by 0.5)=identity (E1 E2 E3 E4 E5 G1 G2 G3 G4 G5 G6 G7 G8 G9 G10); 
output; 
run;
data new; 
set y; 
Y=DV**1;/*Here function of DV means a possible transformation of the original dependent variable, such as log(DV), exp(DV), sqrt(DV), DV^1, DV^2, DV^3, 1/sqrt(DV)*/ 
run;
/*Then we need to computer the two way interaction of the independent variables.*/
data new1; 
set new; 
array one[*] E1 E2 E3 E4 E5 G1 G2 G3 G4 G5 G6 G7 G8 G9 G10; 
array two[*]
e1e2 e1e3 e1e4 e1e5 e1g1 e1g2 e1g3 e1g4 e1g5 e1g6 e1g7 e1g8
     e1g9 e1g10
	 e2e3 e2e4 e2e5 e2g1 e2g2 e2g3 e2g4 e2g5 e2g6 e2g7 e2g8
	 e2g9 e2g10
	      e3e4 e3e5 e3g1 e3g2 e3g3 e3g4 e3g5 e3g6 e3g7 e3g8
	 e3g9 e3g10
	           e4e5 e4g1 e4g2 e4g3 e4g4 e4g5 e4g6 e4g7 e4g8
	 e4g9 e4g10
	                e5g1 e5g2 e5g3 e5g4 e5g5 e5g6 e5g7 e5g8
	 e5g9 e5g10
	                     g1g2 g1g3 g1g4 g1g5 g1g6 g1g7 g1g8
     g1g9 g1g10
	                          g2g3 g2g4 g2g5 g2g6 g2g7 g2g8
     g2g9 g2g10
	                               g3g4 g3g5 g3g6 g3g7 g3g8
     g3g9 g3g10
                                        g4g5 g4g6 g4g7 g4g8
     g4g9 g4g10
	                                         g5g6 g5g7 g5g8
     g5g9 g5g10
	                                              g6g7 g6g8
     g6g9 g6g10
	                                                   g7g8
     g7g9 g7g10

	 g8g9 g8g10

	 g9g10
	 ; 
n=0; 
do i=1 to dim(one); 
do j=i+1 to dim(one);
n=n+1; 
two(n)=one(i)*one(j);
end; 
end; 
run;
/*Then we use the stepwise option in SAS procedure Proc Reg to select the reasonable independent variables at significance level of 0.01*/
proc reg data=new1; 
model Y= E1-E5 G1-G10
e1e2 e1e3 e1e4 e1e5 e1g1 e1g2 e1g3 e1g4 e1g5 e1g6 e1g7 e1g8 
     e1g9 e1g10 
     e2e3 e2e4 e2e5 e2g1 e2g2 e2g3 e2g4 e2g5 e2g6 e2g7 e2g8 
     e2g9 e2g10 
          e3e4 e3e5 e3g1 e3g2 e3g3 e3g4 e3g5 e3g6 e3g7 e3g8 
     e3g9 e3g10 
               e4e5 e4g1 e4g2 e4g3 e4g4 e4g5 e4g6 e4g7 e4g8 
     e4g9 e4g10 
                    e5g1 e5g2 e5g3 e5g4 e5g5 e5g6 e5g7 e5g8 
     e5g9 e5g10 
                         g1g2 g1g3 g1g4 g1g5 g1g6 g1g7 g1g8 
     g1g9 g1g10 
                              g2g3 g2g4 g2g5 g2g6 g2g7 g2g8 
     g2g9 g2g10 
                                   g3g4 g3g5 g3g6 g3g7 g3g8 
     g3g9 g3g10 
                                        g4g5 g4g6 g4g7 g4g8 
     g4g9 g4g10 
                                             g5g6 g5g7 g5g8 
     g5g9 g5g10 
                                                  g6g7 g6g8
     g6g9 g6g10
                                                       g7g8 
     g7g9 g7g10 

     g8g9 g8g10 

     g9g10

	 /selection=stepwise SLENTRY=0.01;
plot residual.*predicted.;
run;


