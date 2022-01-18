#!/bin/bash

score >/dev/null; grep -E "scored|^<br>" /opt/ScoreEngine/ScoreReport.html
