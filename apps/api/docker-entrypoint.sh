#!/bin/sh
set -e

# ১. যদি কন্টেইনার 'api' কমান্ড দিয়ে স্টার্ট হয় (FastAPI Frontend instance)
if [ "$1" = "api" ]; then
  echo "Running database migrations..."
  alembic upgrade head
  
  echo "Starting FastAPI Production Server with 4 Workers..."
  # --workers 4 যুক্ত করায় এটি ব্যাকগ্রাউন্ডে ৪টি প্যারালাল প্রসেস রান করবে, যা হাই-পারফরম্যান্স নিশ্চিত করবে
  exec uvicorn cornerroom.main:app --host 0.0.0.0 --port 8000 --workers 4
fi

# ২. যদি কন্টেইনার 'worker' কমান্ড দিয়ে স্টার্ট হয় (Background Worker)
if [ "$1" = "worker" ]; then
  echo "Starting Background Worker Settings (ARQ)..."
  exec arq cornerroom.worker.WorkerSettings
fi

# ৩. যদি শুধুমাত্র ডাটাবেস মাইগ্রেশন রান করার প্রয়োজন হয়
if [ "$1" = "migrate" ]; then
  echo "Running manual database migrations..."
  exec alembic upgrade head
fi

# অন্য যেকোনো কাস্টম কমান্ড পাস করার জন্য ব্যাকআপ লেয়ার
exec "$@"

