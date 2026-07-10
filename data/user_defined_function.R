##################
#### 定義函數 ####
##################

#函數名稱 <- function(參數){
#  程式重複執行的部份
#}

 add <- function(a, b){
     a + b
 }
 add(1,3)
#[1] 4 # R 預設最後一個運算式當作回傳的值


 add_special <- function(a, b){
   c = a + b
   return(0) # 可以自訂要回傳的部份
 }
 add_special(1,3)
#[1] 0


 add_default <- function(a = 1, b = 2){
  # 可以自訂函數的預設值
   a + b
 }
 add_default() #沒給參數值
#[1] 3
 add_default(2) # 給 a = 2，因為給定參數是依照參數順序，如果想給 b，但不想給定 a，可以利用以下方式
#[1] 4
 add_default(b = 3)
 #[1] 4

 
absolute.sum<-function(n)    ## a function that adds from –n to n
{
     a<-0
     for(i in -n:n)
     {
	     if(i>=0) a<-a+i    ## if i is positive, add i to a
		 else a<-a+(-i)    ## if i negative, add the absolute value –i to a
     }
     return(a)
}
absolute.sum(100) 


absolute.sum1<-function(n)    ## faster implementation
{ return(sum(as.double(abs(-n:n)))) }

absolute.sum(1000000)     ## this will take a while
absolute.sum1(1000000)   ## this will take less than a second

