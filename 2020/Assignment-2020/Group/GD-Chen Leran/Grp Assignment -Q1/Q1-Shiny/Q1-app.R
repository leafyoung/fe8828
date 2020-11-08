library(shiny)
library(DT)
library(FinCal)

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GD-Chen Leran/Grp Assignment -Q1')

load(paste0(wd,"/df1.Rda"))
load(paste0(wd,"/df2.Rda"))
load(paste0(wd,"/df3.Rda"))
load(paste0(wd,"/df_with_M123.Rda"))
load(paste0(wd,"/df_op_client.Rda"))
load(paste0(wd,"/df_sum.Rda"))

ui <- fluidPage(
    h4("Please enter:"),
    textInput(inputId = "account",
              label = "Account No:"),
    
    selectInput(inputId = "month",
                label = "Month:",
                choices = c("Jul","Aug","Sep")),
    
    

    
    actionButton(inputId = "go", 
                 label = "Go"),
    
    
    
    h4("Client Name:"),
    textOutput('Name'),
    h4("Month Selected:"),
    textOutput('Month'),
    
    
    h4("Client View: Transcation History"),
    tableOutput('MonthlySummary'),
    
    sidebarLayout(
        sidebarPanel(
            h4("Chart of Balance")
        ),
        mainPanel(
            tableOutput('MonthlySummary2'),
        )
    ),
    
    sidebarLayout(
        sidebarPanel(
            h4("Bank View: PnL Table"),
        ),
        mainPanel(
            tableOutput('BankSummary'),
        )
    ),
        
    sidebarLayout(
        sidebarPanel(
            h4("Bank View: Risk Table"),
        ),
        mainPanel(
            tableOutput('RiskTable'),
        )
    ),
    
    
    
    
    

)
server <- function(input, output, session) {
    observeEvent(input$go,{
        time=input$month
        id=input$account
        x<-df_sum[df_sum$AccountNo==id & df_sum$Month==time,]
        df_op_client$`Amount(in SGD)`<-as.numeric(df_op_client$`Amount(in SGD)`)
        z<-df_op_client[df_op_client$TransAccountNo==id & df_op_client$Month==time,]
        y<-x$Name
        BegDepBal<-x$BegainningBalance
        BegCreBal<-2000
        
        p<-df_with_M123[df_with_M123$Month==time,]
        p<-aggregate(as.numeric(p$'Amount(in SGD)'),by=c(list(p$Date,p$TransType)),FUN=sum)
        colnames(p)<-c("Date","Type","Amount")
        df_totalDepo<-subset(p,Type=="Deposit")
        df_totalSpend<-subset(p,Type=="Spend")

        q<-full_join(df_totalDepo,df_totalSpend,by="Date")
        q<-cbind(q,Pnl=0)
        q[is.na(q)]<-0
        q$Pnl<-q[,3]-q[,5]
        q<-q[,c(1,3,5,6)]
        colnames(q)<-c("Date","Total Deposit","Total Credit","Pnl from Client Spending")

        r<-df_sum[df_sum$Month==time,]
        r<-cbind(r,CreDepo=0)
        r$CreDepo=r$CreditBalance-r$EndBalance
        r<-r[order(r$CreDepo),]
        r<-r[,c(2,12,14)]
        r<-r[,c(1,3,2)]
        colnames(r)<-c("Client Name","Deposit","Credit")
        
            
        z<-cbind(z,DepositBalance=0)
        z<-cbind(z,CreditBalance=0)
        
        for(row in 1:nrow(z)){
            if (z[row,"TransType"]=="Deposit"){
                z[row, "DepositBalance"] <- BegDepBal+z[row,"Amount(in SGD)"]
                z[row, "CreditBalance"] <- BegCreBal
                BegDepBal <- BegDepBal+z[row,"Amount(in SGD)"]
            }
            else if(z[row,"TransType"]=="Spend"){
                z[row, "DepositBalance"] <- BegDepBal
                z[row, "CreditBalance"] <- BegCreBal-z[row, "Amount(in SGD)"]
                BegCreBal<-BegCreBal-z[row, "Amount(in SGD)"]
            }
            else if(z[row,"TransType"]=="Withdraw"){
                z[row, "DepositBalance"] <- BegDepBal-z[row, "Amount(in SGD)"]
                z[row, "CreditBalance"] <- BegCreBal
                BegDepBal<-BegDepBal-z[row, "Amount(in SGD)"]
            }
            else{
                z[row, "DepositBalance"] <- BegDepBal
                z[row, "CreditBalance"] <- BegCreBal
            }
        }
        
        
        data2<-reactive({
            df_BL<-filter(df_sum,(AccountNo %in% id) &
                       ( Month %in% time))%>%
                select(11:12,14)%>%
                setNames(c("Month End Balance","Deposit","Credit"))
        
            
               
                
        })
        
        
        
        output$MonthlySummary<-renderTable({z
            
        })
        
        output$MonthlySummary2<-renderTable({data2()
            
        })
        
        output$Name<-renderText({
            paste(y)
        })
        
        output$Month<-renderText({
            paste(time)
        })
        
        output$BankSummary<-renderTable({
            q
        })
        
        output$RiskTable<-renderTable({
            r
        })
        
   
    })
}  
shinyApp(ui, server)