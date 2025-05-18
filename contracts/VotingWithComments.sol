// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// تعریف قرارداد اصلی Voting
contract Voting {
    // ساختار داده برای مدل‌سازی هر نامزد
    struct Candidate {
        uint id;            // شناسه کاندیدا (عدد صحیح 256 بیتی بدون علامت)
        string name;        // نام کاندیدا (رشته متنی دینامیک)
        uint voteCount;     // تعداد آراء کسب شده توسط کاندیدا
    }

    // نگاشت شناسه (کلید از نوع uint) به ساختار Candidate (مقادیر نوع Candidate)
    // با استفاده از این mapping می‌توانیم داده‌های مربوط به هر نامزد را بر اساس شناسه‌اش بازیابی کنیم:contentReference[oaicite:6]{index=6}.
    mapping(uint => Candidate) public candidates;

    // نگاشت آدرس کیف‌پول کاربر (کلید از نوع address) به بولین
    // مقدار true به معنی آن است که آن آدرس قبلاً رأی داده است. بدین ترتیب از رأی دوباره جلوگیری می‌شود:contentReference[oaicite:7]{index=7}.
    mapping(address => bool) public voters;

    // شمارنده تعداد کل نامزدها (به منظور تخصیص شناسه یکتا)
    uint public candidatesCount;

    // سازنده‌ی قرارداد (Constructor) که هنگام ایجاد قرارداد یکبار اجرا می‌شود:contentReference[oaicite:8]{index=8}.
    // در اینجا می‌توانیم به‌صورت پیش‌فرض لیستی از نامزدها را اضافه کنیم.
    constructor() {
        // افزودن نمونه‌ای از نامزدها با فراخوانی تابع addCandidate:
        addCandidate("Alice");     // نامزد شماره 1
        addCandidate("Bob");       // نامزد شماره 2
        // می‌توانید به دلخواه نامزدهای بیشتری نیز اضافه کنید.
    }

    // تابع کمکی خصوصی برای اضافه کردن یک نامزد جدید به mapping
    function addCandidate(string memory _name) private {
        // افزایش شمارنده نامزدها و استفاده از مقدار جدید به عنوان شناسه نامزد
        candidatesCount++;
        // اختصاص مقدار به mapping: کلید = شناسه جدید، مقدار = ساختار Candidate جدید
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // تابع رأی دادن؛ هر کسی می‌تواند به یکی از نامزدها رأی دهد.
    function vote(uint _candidateId) public {
        // بررسی اینکه فرستنده تراکنش قبلاً رأی نداده باشد. 
        // اگر این شرط برآورده نشود (یعنی کاربر قبلاً رأی داده)، تراکنش برمی‌گردد:contentReference[oaicite:9]{index=9}:contentReference[oaicite:10]{index=10}.
        require(!voters[msg.sender], "You have already voted");

        // بررسی معتبر بودن شناسه نامزد: باید در بازه [1، candidatesCount] باشد.
        // در صورت نامعتبر بودن، تراکنش را متوقف می‌کنیم.
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        // علامت‌گذاری اینکه این آدرس اکنون رأی داده است (حفظ وضعیت در mapping voters)
        voters[msg.sender] = true;

        // افزایش تعداد آراء کاندیدای مربوطه
        candidates[_candidateId].voteCount += 1;
    }

    // تابع مشاهده نتایج و اطلاعات نامزدها.
    // این تابع یک آرایه از نام نامزدها و یک آرایه متناظرحجم برابر از آراء باز می‌گرداند.
    // توجه کنید که آرایه‌ها در حافظه (memory) ایجاد می‌شوند؛ حافظه موقت است و پس از پایان فراخوانی پاک خواهد شد:contentReference[oaicite:11]{index=11}.
    function getCandidates() public view returns (string[] memory, uint[] memory) {
        // ایجاد آرایه موقتی (in-memory) برای نگهداری نام‌ها و یک آرایه برای تعداد آراء
        string[] memory names = new string[](candidatesCount);
        uint[] memory votes = new uint[](candidatesCount);

        // پیمایش همه نامزدها و پر کردن آرایه‌ها
        for (uint i = 1; i <= candidatesCount; i++) {
            // توجه: ایندکس آرایه‌ها از 0 شروع می‌شود؛ بنابراین از i-1 استفاده می‌کنیم
            names[i-1] = candidates[i].name;
            votes[i-1] = candidates[i].voteCount;
        }
        return (names, votes);
    }
}
