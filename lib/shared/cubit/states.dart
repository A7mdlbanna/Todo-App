abstract class AppStates{}

class AppInitialState extends AppStates{}


/////////////////HomeScreen////////////////////
class AppChangeNavBarState extends AppStates{}
class AppChangeFloatingIconPlusState extends AppStates{}
class AppChangeFloatingIconState extends AppStates{}
class AppClearTask extends AppStates{}

class AppSetDateController extends AppStates{}
class AppSetTimeController extends AppStates{}


/////////////////NewTasks//////////////////
class AppChangeIsDoneState extends AppStates{}
class AppChangeIsImportantState extends AppStates{}


////////////////DataBase//////////////////
class AppChangeTasksValue extends AppStates{}
class AppCreateDatabaseState extends AppStates{}
class AppInsertToDatabaseState extends AppStates{}
class AppGetFromDatabaseState extends AppStates{}
class AppGetFromDatabaseLoadingState extends AppStates{}
class AppUpdateDatabaseState extends AppStates{}
class AppDeleteDatabaseState extends AppStates{}