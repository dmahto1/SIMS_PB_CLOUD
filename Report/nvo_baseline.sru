HA$PBExportHeader$nvo_baseline.sru
$PBExportComments$Common object to facilitate sharing baseline objects across projects.
forward
global type nvo_baseline from nvo
end type
end forward

global type nvo_baseline from nvo
end type
global nvo_baseline nvo_baseline

forward prototypes
public function boolean f_baselinereport (string as_reportid, string as_reportname)
end prototypes

public function boolean f_baselinereport (string as_reportid, string as_reportname);long ll_maxid, ll_numreports
string ls_projectid
boolean lb_success

// Get a list of projects.
DECLARE projects CURSOR FOR 
SELECT distinct(project_id)
FROM project ;

// Open the projects cursor.
OPEN projects;

// If we have a valid open cursor,
If SQLCA.SQLCODE = 0 then 
	
	// Loop through projects.
	Do while true
		
		// Fetch the project id's.
		FETCH projects 
		INTO :ls_projectid;
		
		// If there are no more projects found, exit the loop.
		If SQLCA.SQLCODE = 100 then exit
		
		// Check for the report and project
		Select count(*)
		into :ll_numreports
		From project_reports
		Where project_id = :ls_projectid
		and report_id = :as_reportid;
		
		// If the report does not already exist,
		If ll_numreports = 0 then
		
			// Get the max report id for each project.
			Select max(report_seq) into :ll_maxid from project_reports where project_id = :ls_projectid;
			
			// If the max id is null, make it 0.
			If isnull(ll_maxid) then ll_maxid = 0
			
			// Incriment the max id.
			ll_maxid++
	
			// Insert the report into list for this project.
			insert into project_reports values(:ls_projectid, :as_reportid, :ll_maxid, :as_reportname, '', '');
			
			// Derrive lb_success
			lb_success = sqlca.sqlcode = 0
			
			// If there is a problem,
			If not lb_success then
				
				// Rollback all changes and exit processing.
				Execute Immediate "ROLLBACK" using SQLCA;
				exit
			End If
			
		// End if the report does not already exist
		End If
	
	// Next Project.
	Loop

// End if we have a valid open cursor.
End If

// Close the projects cursor.
CLOSE projects ;

// Commit Changes.
Execute Immediate "COMMIT" using SQLCA;

// Return lb_success
return lb_success
end function

on nvo_baseline.create
call super::create
end on

on nvo_baseline.destroy
call super::destroy
end on

