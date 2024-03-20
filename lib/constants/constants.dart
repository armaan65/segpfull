
import 'package:appwrite/appwrite.dart';



const String APPWRITE_PROJECT_ID = "segp";
const String APPWRITE_DATABASE_ID = "65b204306d142776c878";
const String APPWRITE_URL = "https://cloud.appwrite.io/v1";
const String COLLECTION_ID_MESSAGES = '65d2dc09e10cb3467746';
const String API_ENDPOINT = 'YOUR_API_ENDPOINT';

final Client client = Client()
  .setEndpoint(APPWRITE_URL)
  .setProject(APPWRITE_PROJECT_ID);



final Databases databases = Databases(client);
