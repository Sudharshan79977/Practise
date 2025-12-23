public class CpuTime {
    public static void generateCpuTimeError() {
        Long counter = 0;

        // Intentionally large loop to burn CPU time
        for (Integer i = 0; i < 30000000; i++) {
            counter += i;

            if (Limits.getCpuTime() > 9000) { // near 10,000 ms limit
                System.debug('Approaching CPU limit: ' + Limits.getCpuTime());
            }
        }

        System.debug(counter);
    }
}