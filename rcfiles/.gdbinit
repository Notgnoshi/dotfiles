# See https://stackoverflow.com/questions/30998499/why-my-gdb-prompt-shows-wrong-after-i-change-its-color
# It's necessary to add the \001 and \002 escapes around all non-width characters. This is akin to the \[\] bash escapes.
set prompt \001\033[32m\002(gdb) \001\033[0m\002
set print pretty on
set print array on
set print symbol on

#... This might have been why I have a hard time accessing the backtrace on segfaults...
#handle all nostop
handle SIGUSR1 SIGUSR2 SIGILL nostop

# Do not stop all threads when hitting a breakpoint.
# Has the potential to cause problems, depending on the program.
set pagination off
set non-stop on
# Respond to commands, even when the inferior is running.
set target-async on

# Load local .gdbinit files.
add-auto-load-safe-path /
set auto-load local-gdbinit on

# Save command history
set history save on
set history size unlimited
# Remove duplicates in the last 20 entries.
set history remove-duplicates 20

# Add STL pretty-printers
python
import glob
import sys

gcc = glob.glob("/usr/share/gcc-*")
# TODO: Do something better than grabbing the first match.
sys.path.insert(0, gcc[0] + "/python")

from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers(None)
end
