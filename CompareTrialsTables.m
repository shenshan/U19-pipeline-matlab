 
 
clearvars;
this_path = fileparts(mfilename('fullpath'));
file2save = fullfile(this_path, 'sessions_different_numblocks_withDB.mat');
 
fields_session = {'subject_fullname', 'session_date'};
fields_trials = {'trial_type', ...
'choice', ...
'trial_abs_start', ...
'cue_presence_left', ...
'cue_presence_right', ...
'cue_onset_left', ...
'cue_onset_right', ...
'cue_offset_left', ...
'cue_offset_right', ...
'cue_pos_left', ...
'cue_pos_right', ...
'trial_duration', ...
'excess_travel', ...
'i_arm_entry', ...
'i_blank', ...
'i_cue_entry', ...
'i_mem_entry', ...
'i_turn_entry', ...
'iterations', ...
'trial_id', ...
'trial_prior_p_left', ...
'vi_start'
};

 
date_key = 'session_date <= "2021-03-30"';
 
session_struct = fetch(proj(acquisition.Session,'session_location->sess_loc') * acquisition.SessionStarted, ...
    'remote_path_behavior_file', 'ORDER BY session_date');
num_diff_trials = 0;
 
num_diff_sessions = 0;
for j=1:length(session_struct)
    
        [j length(session_struct)]
    
        tic
        trial_struct = fetch(behavior.TowersBlockTrial & session_struct(j),fields_trials{:});
        toc
        disp(['Time original trial table ', num2str(length(trial_struct))])
        tic
        trials_struct = fetch(behavior.TowersBlockTrials & session_struct(j),fields_trials{:});
        toc
        disp(['Time new trial table', num2str(length(trials_struct))])
   
        tf = isequaln(trial_struct,trials_struct);
        if ~tf
            fields_diff = {};
            status_diff = 0;
            for i=1:length(fields_trials)
                trial_field = {trial_struct.(fields_trials{i})};
                trials_field = {trials_struct.(fields_trials{i})};
                idx_nempty_trial = find(cellfun(@length, trial_field) ~= 0);
                idx_nempty_trials = find(cellfun(@length, trial_field) ~= 0);
                trial_field = trial_field(idx_nempty_trial);
                trials_field = trials_field(idx_nempty_trials);
                tfi = isequaln(trial_field,trials_field);
                if ~tfi
                        fields_diff = [fields_diff fields_trials(i)]
                        status_diff = 1;
                end
            end
            if status_diff
                num_diff_sessions = num_diff_sessions + 1
                aux_key = session_struct(j);
                session_diff_struct(num_diff_sessions) = aux_key;
            end
        end
    
end

save(file2save, 'session_diff_struct', '-v7.3')


