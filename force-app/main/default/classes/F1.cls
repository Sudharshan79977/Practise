public class F1 {
    @future
    public static void f1method(){
        system.debug('this is from F1');
       system.enqueueJob(new Q1());
      // F2.f2method();
    }
}