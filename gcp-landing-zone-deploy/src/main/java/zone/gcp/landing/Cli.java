package zone.gcp.landing;

import com.google.api.gax.paging.Page;
import com.google.auth.appengine.AppEngineCredentials;
import com.google.auth.oauth2.ComputeEngineCredentials;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Bucket;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.common.collect.Lists;
import java.io.FileInputStream;
import java.io.IOException;

public class Cli {
    

    public static void main(String[] args) {

       // Credentials credentials = null;
        // TODO: Replace with your project ID in the form "projects/your-project-id".
        String projectId = "lz-stg";
        // TODO: Replace with the ID of your member in the form "user:member@example.com"
        String member = "user:michael@obrienlabs.dev";
        // The role to be granted.
        String role = "roles/logging.logWriter";
    
        // Initializes the Cloud Resource Manager service.
        System.out.println("classloading");

        // https://github.com/GoogleCloudPlatform/java-docs-samples/tree/826cfbefa10e4eb353241f97e48b4bfbbf05e0cb/auth
        // If you don't specify credentials when constructing the client, the client library will
  // look for credentials via the environment variable GOOGLE_APPLICATION_CREDENTIALS.
  Storage storage = StorageOptions.getDefaultInstance().getService();

  System.out.println("Buckets:");
  Page<Bucket> buckets = storage.list();
  for (Bucket bucket : buckets.iterateAll()) {
    System.out.println(bucket.toString());
  }
}
}



