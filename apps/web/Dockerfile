# Step 1: শুধুমাত্র প্রয়োজনীয় ডিপেনডেন্সি ইনস্টল করার লেয়ার
FROM node:22-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# মনোরেপো স্ট্রাকচার অনুযায়ী সঠিক পাথ থেকে প্যাকেজ ফাইল কপি করা
COPY package.json package-lock.json* ./
# শুধুমাত্র প্রোডাকশন প্যাকেজ ইনস্টল করবে (ডেভ ফাইল বাদ যাবে)
RUN npm ci --omit=dev

# Step 2: সোর্স কোড বিল্ড করার লেয়ার
FROM node:22-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# প্রোডাকশন ব্যাকএন্ড এপিআই ইউআরএল (Nginx-এর মাধ্যমে রাউট হবে)
ARG NEXT_PUBLIC_API_URL=https://cornerroom.live
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

# Next.js প্রোডাকশন অপ্টিমাইজড বিল্ড তৈরি করা
RUN npm run build

# Step 3: চূড়ান্ত প্রোডাকশন রানার (সব ডেভ ফাইল ও এক্সট্রা মডিউল এখানে বাদ পড়ে যাবে)
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# সিকিউরিটির জন্য নন-রুট ইউজার তৈরি করা
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1002 nextjs

# শুধুমাত্র বিল্ড হওয়া প্রোডাকশন-রেডি ফাইলগুলো কপি করা
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

# প্রোডাকশন সার্ভার স্টার্ট কমান্ড
CMD ["node", "server.js"]
