# Script to log current and then apply new performance settings

# Usage:
```
bash read-performance-settings.sh |& tee -a backup_$(date "+%Y-%m-%d").txt

bash enable-performance-optimization.sh |& tee -a log_$(date "+%Y-%m-%d").txt
```
