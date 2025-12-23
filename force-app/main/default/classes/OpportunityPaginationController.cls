public class OpportunityPaginationController {
    
    public List<Opportunity> opportunities { get; set; }
    public Integer pageSize { get; set; }
    public Integer pageNumber { get; set; }
    public Integer totalRecords { get; set; }
    
    public OpportunityPaginationController() {
        pageSize = 10;
        pageNumber = 1;
        totalRecords = [SELECT COUNT() FROM Opportunity];
        loadOpportunities();
    }
    
    public void loadOpportunities() {
        Integer offsetValue = (pageNumber - 1) * pageSize;
        opportunities = [
            SELECT Id, Name, StageName, Amount, CloseDate, Account.Name 
            FROM Opportunity 
            ORDER BY CreatedDate DESC
            LIMIT :pageSize OFFSET :offsetValue
        ];
    }
    
    public void nextPage() {
        if (pageNumber * pageSize < totalRecords) {
            pageNumber++;
            loadOpportunities();
        }
    }
    
    public void previousPage() {
        if (pageNumber > 1) {
            pageNumber--;
            loadOpportunities();
        }
    }
    
    public Boolean getHasNext() {
        return (pageNumber * pageSize) < totalRecords;
    }
    
    public Boolean getHasPrevious() {
        return pageNumber > 1;
    }
}