FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/src

# ১. সিস্টেম ডিপেনডেন্সি ইনস্টল করা
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 💡 ২. বিল্ড ক্যাশ অপ্টিমাইজেশন (আগে শুধুমাত্র ডিপেনডেন্সি ফাইল কপি করা)
COPY apps/api/pyproject.toml /app/pyproject.toml
# যদি আপনার প্রজেক্টে poetry.lock বা setup.py বা requirements.txt থাকে, সেগুলোও এখানে কপি করুন:
# COPY apps/api/poetry.lock* /app/poetry.lock*

# 💡 ৩. প্রোডাকশন মুডে ইনস্টল করা (Editable '-e' ফ্ল্যাগ ছাড়া এবং ক্যাশ ছাড়া)
RUN pip install --no-cache-dir .

# ৪. এবার শুধুমাত্র প্রয়োজনীয় প্রোডাকশন সোর্স ফাইলগুলো কপি করা
COPY apps/api/src /app/src
COPY apps/api/alembic /app/alembic
COPY apps/api/alembic.ini /app/alembic.ini
COPY apps/api/docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["api"]
