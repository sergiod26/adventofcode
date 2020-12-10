using System;

namespace AdventCode
{
    class Day25 : Day
    {
        public override int Number => 25;
        public override double PartA()
        {
            long value = 1;
            long cardKey = 14788856;
            long doorKey = 19316454;

            var cardIt = 0;
            for (; value != cardKey; cardIt++)
            {
                value = (value * 7) % 20201227;
            }

            value = 1;
            var doorIt = 0;
            for (; value != doorKey; doorIt++)
            {
                value = (value * 7) % 20201227;
            }


            long encryptionKey = 1;
            for (int i = 0; i < doorIt; i++)
            {
                encryptionKey = (encryptionKey * cardKey) % 20201227;
            }

            value = 1;
            for (int i = 0; i < cardIt; i++)
            {
                value = (value * doorKey) % 20201227;
            }

            if (encryptionKey != value)
            {
                throw new Exception();
            }

            return encryptionKey;
        }

        public override double PartB()
        {
            return -1;
        }
    }
}
