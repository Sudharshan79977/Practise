public class HeapSize {
    public static void generateHeapError() {
        List<String> bigList = new List<String>();

        // Keep adding large strings until heap overflow
        for (Integer i = 0; i < 500000; i++) {
            // Add a long string to consume memory
            bigList.add(String.valueOf(i) + ' - ' + String.valueOf(Crypto.generateDigest('SHA1', Blob.valueOf('test'))));

            if (Limits.getHeapSize() > (5500000)) {
                System.debug('Approaching heap limit: ' + Limits.getHeapSize());
            }
        }
    }
}