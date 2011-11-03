
var editor;
var original_code;
var last_saved_code = null;
var save_timeout = null;
var saving = false;
var loading = false;
var reload_when_finished = false;
var commit_index_to_load;
var revisions = new Array();
var num_changes;
var changes;

window.onload = function() {
  editor = ace.edit("app_code");
  original_code = get_code();
  
  var Mode = require("ace/mode/ruby").Mode;
  editor.getSession().setMode(new Mode());
};

function remember_code(id) {
  last_saved_code = get_code();
}

function store_code_in_form() {
  $("#hidden_app_code").attr("value", get_code());
}

function handle_change(id) {
  if (!editing) return;
  schedule_or_delay_a_save();
}

function schedule_or_delay_a_save() {
  if (save_timeout != null) {
    clearTimeout(save_timeout);
  }

  save_timeout = setTimeout(autosave, 2000);
}

function autosave() {
  if (saving) {
    schedule_or_delay_a_save();
  } else {
    code = get_code();
    if (code != last_saved_code) {
      saving = true;
      make_save_request();
      last_saved_code = code;
    }
    clearTimeout(save_timeout);
  }
}

function make_save_request() {
   new Ajax.Request('<%= app_path(@app, "files/app.rb") %>', 
    { 
      method:'put',
      parameters: 
        {
          "authenticity_token": "<%= form_authenticity_token %>",
          "app_code": get_code()
        },
      onSuccess: function(transport) {
        saving = false;
        set_num_changes(transport.responseJSON.changes_since_last_full_commit);
        set_stars(transport.responseJSON.commits);
        set_slider_size(transport.responseJSON.commit_count-1);
      },
      onFailure: function() { alert("fail!"); }
    });   
}

function load_commit(index) {
  if (loading) {
    reload_when_finished = true;
    commit_index_to_load = index;
  } else {
    if (revisions[index]) {
      set_code(revisions[index]);
      return;
    }
    loading = true;
    new Ajax.Request('<%= app_commits_path(@app) %>/' + index, 
      { 
        method:'get',
        onSuccess: function(transport) {
          loading = false;
          revisions[transport.responseJSON.index] = transport.responseJSON.text
          set_code(transport.responseJSON.text);
          if (reload_when_finished) {
            load_commit(commit_index_to_load);
            reload_when_finished = false;
          }
        },
        onFailure: function() { alert("fail!"); }
      }); 
  }
}

function get_code() {
  editor.getSession().getValue();
}

function set_code(code) {
  editor.getSession().setValue(code);
  original_code = code
  remember_code();
}

function set_num_changes(num) {
  num_changes = num;
  changes = (num > 0)
  label = (num > 1) ? "changes" : "change"
  $j("#commit_slider").toggleClass('with_changes', changes);
  $j("#commit_slider").toggleClass('without_changes', !changes);
  $j("#changes").html(num + " " + label + "!");
  $j("#changes").toggleClass('off', !changes);
  $j("#save_button").toggleClass('off', !changes);
}

function set_slider_size(num) {
  $j("#commit_slider").slider('option', 'max', num);
}

function save() {
  var msg = prompt("What are you saving?");
  new Ajax.Request('<%= app_commits_path(@app) %>', 
  { 
    method:'post',
    parameters: {
      'message': msg,
      'authenticity_token':'<%= form_authenticity_token %>'
    },
    onSuccess: function(transport) {
      set_num_changes(0);
      set_stars(transport.responseJSON.commits);
    },
    onFailure: function() { alert("fail!"); }
  });   
}

function set_stars(commits) {
  $j("#commit_stars").html('');
  for(var i=0; i<commits.length; i++) {
    if (commits[i].full) {
      width = changes ? 438.0 : 495.0;
      left = i / (commits.length-1) * width - 3;
      $j("#commit_stars").html($j("#commit_stars").html() 
        + '<img src="/images/star.png" onclick="" style="position: relative; left: ' 
        + left + 'px; top: -3px; margin-right: -16px;" alt="' + commits[i]['message'] + '" '
        + " onmouseover=\"show_commit('" + commits[i]['message'] + "', '" + left + "');\" "
        + " onmouseout=\"hide_commit();\">");
    }
  }
}

function show_commit(message, left) {
  $("commit_bubble").style.left = (left-5) + 'px';
  $j("#commit_bubble").html(message);
  $("commit_bubble").style.display = "block";
}

function hide_commit() {
  $("commit_bubble").style.display = "none";
}

function initialize_slider() {
  new Ajax.Request('<%= app_commits_path(@app) %>', 
  { 
    method:'get',
    onSuccess: function(transport) {
      set_num_changes(transport.responseJSON.changes_since_last_full_commit);
      set_slider_size(transport.responseJSON.total_changes-1);
      set_stars(transport.responseJSON.commits);
    },
    onFailure: function() { alert("fail!"); }
  });
}