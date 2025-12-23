trigger AccountTriiger on Account (before update) {
    List<Account> accList = new List<Account>();

    for(Account acc : trigger.new){
        if(acc.Rating == 'Cold'){
           
               acc.Rating = 'Hot';
                    
            }}
    
}