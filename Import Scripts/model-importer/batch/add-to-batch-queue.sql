TRUNCATE TABLE batch_task_queue;

INSERT INTO batch_task_queue (Command)
SELECT Command FROM neuromldb.problematic_models_waveforms_without_stats;

SELECT CONCAT('python manage.py save_model_properties ', Model_ID, ' wave_stats'), m.* FROM neuromldb.models m
WHERE Type in ('CH')
;




# All tasks
SELECT * FROM neuromldb.batch_task_queue;

# Remaining tasks
SELECT * FROM neuromldb.batch_task_queue WHERE Status in (0,1);

#Percent done
SELECT ((SELECT COUNT(*) FROM neuromldb.batch_task_queue WHERE Status not in (0,1))/(SELECT COUNT(*) FROM neuromldb.batch_task_queue)  * 100) as DONE;


#call get_next_task();


#call finish_task(5);

#Pause
UPDATE batch_task_queue SET Status = 4 WHERE Status = 0

#Resume
UPDATE batch_task_queue SET Status = 0 WHERE Status = 4

# Reset
UPDATE batch_task_queue SET Status = 0

UPDATE batch_task_queue SET Command = REPLACE(Command, "spike_counts", "wave_stats")